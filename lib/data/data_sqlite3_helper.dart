import 'dart:async';

import 'package:VirtualFlightThrottle/data/data_app_settings.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQLite3Helper {

  static final SQLite3Helper _singleton = new SQLite3Helper._internal();

  factory SQLite3Helper() => _singleton;

  SQLite3Helper._internal();

  static const String DB_NAME = "virtual_throttle_database.db";
  static const int DB_VERSION = 4;

  Database _db;

  Future<void> initializeDb() async {
    this._db = await openDatabase(
      join((await getApplicationDocumentsDirectory()).path, DB_NAME),
      version: DB_VERSION,
      onCreate: _createTables,
      onOpen: (db) => this._createTables(db, DB_VERSION),
    );
  }

  void _createTables(Database db, int version) async {
    await db.execute(
      "CREATE TABLE IF NOT EXISTS settings("
          "settings_type TEXT PRIMARY KEY, "
          "value TEXT"
      ")");
    await db.execute(
      "CREATE TABLE IF NOT EXISTS layouts("
        "layout_name TEXT PRIMARY KEY, "
        "value TEXT, "
        "date DATETIME DEFAULT CURRENT_TIMESTAMP"
      ")");
    await db.execute(
      "CREATE TABLE IF NOT EXISTS registered_devices("
        "address TEXT PRIMARY KEY"
      ")"
    );
  }

  // Settings

  Future<Map<SettingsType, String>> getSavedSettingsValue() async {
    List<Map> list = await this._db.rawQuery('SELECT * FROM settings');
    Map<SettingsType, String> settingsList = new Map<SettingsType, String>();
    list.forEach((value) => settingsList[getEnumFromString(SettingsType.values, value["settings_type"])] = value["value"]);
    return settingsList;
  }

  Future<void> insertSettings(SettingsType settingsType) async {
    await this._db.insert(
      "settings", {
      "settings_type": settingsType.toString(),
      "value": AppSettings().settingsMap[settingsType].toString(),
    },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Layouts

  Future<Map<String, String>> getSavedLayoutList() async {
    List<Map> list = await this._db.rawQuery('SELECT * FROM layouts');
    Map<String, String> layoutJSON = new Map<String, String>();
    list.forEach((value) => layoutJSON[value["layout_name"]] = value["value"]);
    return layoutJSON;
  }

  Future<void> insertLayout(String layoutName, String layoutJSON) async {
    await this._db.insert(
      "layouts", {
      "layout_name": layoutName,
      "value": layoutJSON,
    },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Network

  Future<List<String>> getSavedRegisteredDevices() async {
    List<Map> list = await this._db.rawQuery('SELECT * FROM registered_devices');
    return List<String>.generate(list.length, (idx) => list[idx]["address"]);
  }

  Future<void> insertRegisteredDevices(String address) async {
    await this._db.insert(
      "registered_devices", {
      "address": address,
    },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

}