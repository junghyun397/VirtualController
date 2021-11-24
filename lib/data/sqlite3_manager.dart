import 'dart:async';

import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tekartik_app_flutter_sqflite/sqflite.dart';

class SQLite3Manager {

  static const String DB_NAME = "virtual_throttle_database.db";
  static const int DB_VERSION = 6;

  late Database _db;

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
      "CREATE TABLE IF NOT EXISTS panels("
        "panel_name TEXT PRIMARY KEY, "
        "value TEXT"
      ")");
    await db.execute(
      "CREATE TABLE IF NOT EXISTS registered_devices("
        "address TEXT PRIMARY KEY"
      ")"
    );
  }

  // Settings

  Future<Map<SettingsType, String>> getSavedSettingsValue() async =>
     Map.fromIterable(await this._db.rawQuery("SELECT * FROM settings"),
        key: (val) => getEnumFromString(SettingsType.values, val["settings_type"]),
        value: (val) => val["settings_type"],
     );

  Future<void> insertSettings(SettingsType settingsType, SettingData settingData) async =>
    await this._db.insert(
      "settings", {
      "settings_type": settingsType.toString(),
      "value": settingData.toString(),
    },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  // Penal

  Future<Map<String, String>> getSavedPanelList() async =>
      Map.fromIterable(await this._db.rawQuery('SELECT * FROM panels'),
          key: (val) => val["panel_name"],
          value: (val) => val["value"],
      );

  Future<void> insertPanel(String layoutName, String layoutJSON) async =>
    await this._db.insert(
      "panels", {
      "panel_name": layoutName,
      "value": layoutJSON,
    },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  Future<void> removePanel(String panelName) async =>
    await this._db.delete("panels", where: "panel_name = ?", whereArgs: [panelName]);

  // Network

  Future<List<String>> getSavedRegisteredDevices() async =>
    (await this._db.rawQuery('SELECT * FROM registered_devices'))
        .map((val) => val["address"] as String).toList(growable: false);

  Future<void> insertRegisteredDevices(String address) async =>
    await this._db.insert(
      "registered_devices", {
      "address": address,
    },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

}