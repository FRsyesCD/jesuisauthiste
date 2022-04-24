// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_to_speech/text_to_speech.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _npfr = '';
  var _npar = '';
  dynamic data;
  static late SharedPreferences prefs;
  TextToSpeech tts = TextToSpeech();
  static Image _pdp = Image(
    image: AssetImage('assets/images/pdp.png'),
  );
  @override
  void initState() {
    super.initState();
    prefsInit().then((value) => setState(() {
          _npfr = prefs.getString('npfr').toString();
          _npar = prefs.getString('npar').toString();
          getImage();
        }));
  }

  Future<void> getImage() async {
    Uint8List bytes = base64Decode(prefs.getString("pdp").toString());
    _pdp = Image.memory(bytes, fit: BoxFit.fill);
  }

  Future<void> prefsInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            child: AppBar(
                flexibleSpace: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                      width: 110,
                      height: 110,
                      child: ClipRRect(
                        child: _pdp,
                        borderRadius: BorderRadius.circular(110),
                      )),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _npfr,
                      style: TextStyle(
                          fontFamily: 'Seguo UI',
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )),
            preferredSize: const Size.fromHeight(130.0)),
        body: FutureBuilder(
          builder: (context, snapshot) {
            data = json.decode(snapshot.data.toString());
            return GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: data != null ? data.length : 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 17,
                    mainAxisSpacing: 17),
                padding: EdgeInsets.all(14),
                itemBuilder: (context, i) {
                  return GestureDetector(
                    child: Image(
                        image: AssetImage('assets/images/' + data[i]['image'])),
                    onTap: () async {
                      dynamic voices = await tts.getVoiceByLang('ar');
                      tts.setLanguage(
                          data[i]['lang'] + prefs.getString('gender') == 'male'
                              ? '-standard-a'
                              : '-standard-b');
                      String tospeak =
                          (data[i]['lang'] == 'ar' ? _npar : _npfr) +
                              ' ' +
                              data[i]['words'];
                      tts.speak(tospeak);
                    },
                  );
                });
          },
          future: DefaultAssetBundle.of(context)
              .loadString("assets/jsonfiles/data.json"),
        ));
  }
}
