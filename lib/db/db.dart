import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static var database;

  static void initializedb() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'jesuisautiste.db'),
      onCreate: (db, version) {
        return db.execute(
          "",
        );
      },
      version: 1,
    );
  }
}
