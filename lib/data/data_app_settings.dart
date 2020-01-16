import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:flutter/cupertino.dart';

abstract class SettingData<T> {
  T value;
  T defaultValue;

  String settingName;
  String description;

  SettingData({
  @required this.defaultValue,
  @required this.settingName,
  @required this.description}) {
    this.value = this.defaultValue;
  }

  void setValue(String sourceString);

  @override
  String toString() {
    return value.toString();
  }
}

class StringSettingData extends SettingData<String> {
  StringSettingData({String defaultValue, String settingName, String description}): super(defaultValue: defaultValue, settingName: settingName, description: description);

  @override
  void setValue(String sourceString) => value = sourceString;
}

class BooleanSettingData extends SettingData<bool> {
  BooleanSettingData({bool defaultValue, String settingName, String description}): super(defaultValue: defaultValue, settingName: settingName, description: description);

  @override
  void setValue(String sourceString) => value = sourceString.toUpperCase() == "TRUE" ? true : false;
}

class IntegerSettingData extends SettingData<int> {
  IntegerSettingData({int defaultValue, String settingName, String description}): super(defaultValue: defaultValue, settingName: settingName, description: description);

  @override
  void setValue(String sourceString) => value = int.parse(sourceString);
}

enum NetworkType {WIFI, BLUETOOTH}
class NetworkTypeSettingData extends SettingData<NetworkType> {
  NetworkTypeSettingData({NetworkType defaultValue, String settingName, String description}) : super(defaultValue: defaultValue, settingName: settingName, description: description);

  @override
  void setValue(String sourceString) => value = UtilityDart.getEnumFromString(NetworkType.values, sourceString);
}

enum SettingsType {
  USER_NAME,
  USER_PWD,
  USE_DARK_THEME,
  HIDE_TOP_BAR,
  HIDE_HOME_KEY,
  NETWORK_TYPE,
  AUTO_CONNECTION,
  NETWORK_TIMEOUT,
  USE_VIBRATION,
}

class AppSettings {

  static final AppSettings _singleton = new AppSettings._internal();
  factory AppSettings() =>  _singleton;
  AppSettings._internal();

  Map<SettingsType, SettingData> settingsMap = _buildDefaultSettings();

  void resetGlobalSettings() {
    this.settingsMap = _buildDefaultSettings();
    SettingsType.values.forEach((val) => SQLite3Helper().insertSettings(val));
  }

  Future<void> loadSavedGlobalSettings() async {
    Map<SettingsType, SettingData> result = _buildDefaultSettings();
    await SQLite3Helper().getSavedSettingsValue().then((val) => val.forEach((key, value) => result[key].setValue(value)));
    this.settingsMap = result;
  }

  static Map<SettingsType, SettingData> _buildDefaultSettings() {
    return {
      SettingsType.USER_NAME: new StringSettingData(
        defaultValue: "anonymous",
        settingName: "User name",
        description: "Set nickname when sharing layout",
      ),
      SettingsType.USER_PWD: new StringSettingData(
        defaultValue: "",
        settingName: "User password",
        description: "Use password when sharing layout",
      ),
      SettingsType.USE_DARK_THEME: new BooleanSettingData(
          defaultValue: false,
          settingName: "Use dark theme",
          description: "Use a Dark theme (Applies after restart)"),
      SettingsType.HIDE_TOP_BAR: new BooleanSettingData(
        defaultValue: true,
        settingName: "Hide topbar",
        description: "Enable auto top bar hide",
      ),
      SettingsType.HIDE_HOME_KEY: new BooleanSettingData(
        defaultValue: true,
        settingName: "Hide homekey",
        description: "Enable auto home key hide",
      ),
      SettingsType.USE_VIBRATION: new BooleanSettingData(
        defaultValue: true,
        settingName: "Use vibration",
        description: "Enable vibration feedback"
      ),

      SettingsType.NETWORK_TYPE: new NetworkTypeSettingData(
        defaultValue: NetworkType.WIFI,
        settingName: "Network Type",
          description: "Set network interface for PC side device"
      ),
      SettingsType.NETWORK_TIMEOUT: new IntegerSettingData(
        defaultValue: 1500,
        settingName: "Network Timeout",
        description: "Set device discovery and connection timeout (ms)",
      ),
      SettingsType.AUTO_CONNECTION: new BooleanSettingData(
        defaultValue: true,
        settingName: "Auto connection",
        description: "Enable automatic connection at startup",
      ),
    };
  }

}
