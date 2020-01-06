import 'dart:async';
import 'dart:io' as io;

import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'data_app_settings.dart';

class SQLite3Helper {

  static final SQLite3Helper _singleton = new SQLite3Helper._internal();
  factory SQLite3Helper() =>  _singleton;
  SQLite3Helper._internal();

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await _initializeDb();
    return _db;
  }

  Future<Database> _initializeDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "virtual_throttle_database.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE settings("
          "settings_type TEXT PRIMARY KEY, "
          "value TEXT"
      ");"

      "CREATE TABLE layouts("
          "layout_name TEXT PRIMARY KEY, "
          "value TEXT, "
          "date DATETIME DEFAULT CURRENT_TIMESTAMP"
      ");"
    );
  }

  // Layouts

  Future<Map<String, String>> getSavedLayoutJSON() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM layouts');
    Map<String, String> layoutJSON = new Map<String, String>();
    list.forEach((value) => layoutJSON[value["layout_name"]] = value["value"]);
    return layoutJSON;
  }

  Future<void> insertLayoutJSON(String layoutName, String layoutJSON) async {
    var dbClient = await db;
    await dbClient.insert(
      "layouts",
      {
        "layout_name": layoutName,
        "value": layoutJSON,
      },
    );
  }

  // Settings

  Future<Map<SettingsType, String>> getSavedSettingsValue() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM settings');
    Map<SettingsType, String> settingsList = new Map<SettingsType, String>();
    list.forEach((value) => settingsList[UtilityDart.getEnumFromString(SettingsType.values, value["settings_type"])] = value["value"]);
    return settingsList;
  }

  Future<void> insertSettings(SettingsType settingsType) async {
    var dbClient = await db;
    await dbClient.insert(
      "settings",
      {
        "settings_type": settingsType.toString(),
        "value": AppSettings().settingsMap[settingsType].toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}