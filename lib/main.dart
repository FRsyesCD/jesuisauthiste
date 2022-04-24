// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jesuisauthiste/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var npfr = prefs.getString('npfr');
  var npar = prefs.getString('npar');
  var np = npfr ?? npar;
  runApp(MaterialApp(
      home: np == null ? Login(title: 'je suis authiste') : HomePage()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jesuisauthiste',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(title: 'je suis authiste'),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  var _selectedGender;
  Image _pdp = Image(image: AssetImage('assets/images/pdp.png'));
  final TextEditingController npfr = TextEditingController();
  final TextEditingController npar = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: npfr,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom Prénom',
                  hintText: 'Entrer le Nom et Prénom en français'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: npar,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'الاسم و النسب',
                  hintText: 'ادخل الاسم و النسب بالعربية'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Radio<String>(
                      value: 'male',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                    title: const Text('Masculin'),
                  ),
                  ListTile(
                    leading: Radio<String>(
                      value: 'female',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                    title: const Text('feminin'),
                  ),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: GestureDetector(
                      child: ClipRRect(
                        child: _pdp,
                        borderRadius: BorderRadius.circular(150),
                      ),
                      onTap: () async {
                        try {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          final path = image?.path;

                          final bytes =
                              await File(path.toString()).readAsBytes();
                          setState(() {
                            _pdp = Image.memory(bytes);
                          });
                          String base64Image = base64Encode(bytes);
                          WidgetsFlutterBinding.ensureInitialized();
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("pdp", base64Image);
                        } catch (e) {
                          if (kDebugMode) {
                            print('null image');
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: () async {
                if (npfr.text != "" && npar.text != "") {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('npfr', npfr.text);
                  prefs.setString('npar', npar.text);
                  prefs.setString('gender', _selectedGender);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Erreur: svp entrez tous les champs'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
