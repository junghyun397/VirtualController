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

  Database _db;

  Future<void> initializeDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "virtual_throttle_db.db");
    _db = await openDatabase(path, version: 3, onCreate: _onCreate);
  }

  Future<void> _insertOrUpdate(String table, Map<String, dynamic> values) async {
    int id = await this._db.update(table, values);
    if (id == 0) await this._db.insert(table, values);
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

      "CREATE TABLE registered_devices("
          "address TEXT PRIMARY KEY"
      ");"
    );
  }

  // Settings

  Future<Map<SettingsType, String>> getSavedSettingsValue() async {
    List<Map> list = await _db.rawQuery('SELECT * FROM settings');
    Map<SettingsType, String> settingsList = new Map<SettingsType, String>();
    list.forEach((value) => settingsList[UtilityDart.getEnumFromString(SettingsType.values, value["settings_type"])] = value["value"]);
    return settingsList;
  }

  Future<void> insertSettings(SettingsType settingsType) async {
    await _db.insert(
      "settings", {
        "settings_type": settingsType.toString(),
        "value": AppSettings().settingsMap[settingsType].toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Layouts

  Future<Map<String, String>> getSavedLayoutJSON() async {
    List<Map> list = await _db.rawQuery('SELECT * FROM layouts');
    Map<String, String> layoutJSON = new Map<String, String>();
    list.forEach((value) => layoutJSON[value["layout_name"]] = value["value"]);
    return layoutJSON;
  }

  Future<void> insertLayoutJSON(String layoutName, String layoutJSON) async {
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
    List<Map> list = await _db.rawQuery('SELECT * FROM registered_devices');
    return List<String>.generate(list.length, (idx) {
      return list[idx]["address"];
    });
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