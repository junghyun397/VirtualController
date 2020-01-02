import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'data_global_settings.dart';

class SQLite3Helper {

  static final SQLite3Helper _singleton = new SQLite3Helper._internal();
  factory SQLite3Helper() =>  _singleton;
  SQLite3Helper._internal();

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initializeDb();
    return _db;
  }

  initializeDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "virtual_throttle_database.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE settings(settings_type TEXT PRIMARY KEY, value TEXT)");
  }

  Future<Map<SettingsType, String>> getSavedSettingsValue() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM settings');
    Map<SettingsType, String> settingsList = new Map<SettingsType, String>();
    for (int i = 0; i < list.length; i++) {
      settingsList[getSettingsTypeFromString(list[i]["settings_type"])] = list[i]["value"];
    }
    return settingsList;
  }

  Future<void> insertSettings(SettingsType settingsType) async {
    var dbClient = await db;
    await dbClient.insert(
      "settings",
      {
        "settings_type": settingsType.toString(),
        "value": GlobalSettings().settingsMap[settingsType].toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}