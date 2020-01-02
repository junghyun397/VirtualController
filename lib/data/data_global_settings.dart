import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';

enum SettingsType {
  USER_NAME,
  USER_PWD,

  HIDE_TOP_BAR,
  HIDE_HOME_KEY,

  AUTO_CONNECTION,

  USE_VIBRATION,
}

SettingsType getSettingsTypeFromString(String sourceString) {
  SettingsType result;
  SettingsType.values.forEach((val) {
    if (val.toString() == sourceString) result = val;
  });
  return result;
}

abstract class SettingData<T> {
  T value;
  T defaultValue;

  String settingName;
  String description;

  SettingData(
    this.defaultValue,
    this.settingName, this.description) {
    this.value = this.defaultValue;
  }

  void setValue(String sourceString);

  @override
  String toString() {
    return value.toString();
  }
}

class StringSettingData extends SettingData<String> {
  StringSettingData({String defaultValue, String settingName, String description}): super(defaultValue, settingName, description);

  @override
  void setValue(String sourceString) => value = sourceString;

}

class BooleanSettingData extends SettingData<bool> {
  BooleanSettingData({bool defaultValue, String settingName, String description}): super(defaultValue, settingName, description);

  @override
  void setValue(String sourceString) => value = sourceString.toUpperCase() == "TRUE" ? true : false;

}


class IntegerSettingData extends SettingData<int> {
  IntegerSettingData({int defaultValue, String settingName, String description}): super(defaultValue, settingName, description);

  @override
  void setValue(String sourceString) => value = int.parse(sourceString);
}

class GlobalSettings {

  static final GlobalSettings _singleton = new GlobalSettings._internal();
  factory GlobalSettings() =>  _singleton;
  GlobalSettings._internal();

  Map<SettingsType, SettingData> settingsMap = _loadSavedGlobalSettings();

  void resetGlobalSettings() {
    this.settingsMap = _buildDefaultSettings();
    SettingsType.values.forEach((val) => SQLite3Helper().insertSettings(val));
  }

  static Map<SettingsType, SettingData> _loadSavedGlobalSettings() {
    Map<SettingsType, SettingData> result = _buildDefaultSettings();
    var sync = () async {
      Map<SettingsType, String> settingsList = await SQLite3Helper().getSavedSettingsValue();
      settingsList.forEach((key, value) {
        result[key].setValue(value);
      });
    };
    sync();
    return result;
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

      SettingsType.HIDE_TOP_BAR: new BooleanSettingData(
        defaultValue: true,
        settingName: "Hide topbar",
        description: "Enable auto top bar hide",
      ),
      SettingsType.HIDE_HOME_KEY: new BooleanSettingData(
        defaultValue: false,
        settingName: "Hide homekey",
        description: "Enable auto home key hide",
      ),

      SettingsType.AUTO_CONNECTION: new BooleanSettingData(
        defaultValue: true,
        settingName: "Auto connection",
        description: "Enable automatic connection at startup",
      ),

      SettingsType.USE_VIBRATION: new BooleanSettingData(
        defaultValue: true,
        settingName: "Use vibration",
        description: "Enable vibration feedback"
      )
    };
  }

}
