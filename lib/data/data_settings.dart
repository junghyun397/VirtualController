import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:VirtualFlightThrottle/generated/l10n.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:flutter/cupertino.dart';

abstract class SettingData<T> {
  T value;
  final T defaultValue;
  
  final String Function(BuildContext) getL10nName;
  final String Function(BuildContext) getL10nDescription;

  SettingData({
    @required this.defaultValue,
    @required this.getL10nName,
    @required this.getL10nDescription,
  }) {
    this.value = this.defaultValue;
  }

  void setValue(String sourceString);

  @override
  String toString() {
    return value.toString();
  }
}

class StringSettingData extends SettingData<String> {
  StringSettingData({String defaultValue, String Function(BuildContext) getL10nName, String Function(BuildContext) getL10nDescription}): 
        super(defaultValue: defaultValue, getL10nName: getL10nName, getL10nDescription: getL10nDescription);

  @override
  void setValue(String sourceString) => value = sourceString;
}

class BooleanSettingData extends SettingData<bool> {
  BooleanSettingData({bool defaultValue, String Function(BuildContext) getL10nName, String Function(BuildContext) getL10nDescription}): 
        super(defaultValue: defaultValue, getL10nName: getL10nName, getL10nDescription: getL10nDescription);

  @override
  void setValue(String sourceString) => value = sourceString.toUpperCase() == "TRUE" ? true : false;
}

class IntegerSettingData extends SettingData<int> {
  IntegerSettingData({int defaultValue, String Function(BuildContext) getL10nName, String Function(BuildContext) getL10nDescription}): 
        super(defaultValue: defaultValue, getL10nName: getL10nName, getL10nDescription: getL10nDescription);

  @override
  void setValue(String sourceString) => value = int.parse(sourceString);
}

enum NetworkType {WIFI, BLUETOOTH, USB_SERIAL}
class NetworkTypeSettingData extends SettingData<NetworkType> {
  NetworkTypeSettingData({NetworkType defaultValue, String Function(BuildContext) getL10nName, String Function(BuildContext) getL10nDescription}) : 
        super(defaultValue: defaultValue, getL10nName: getL10nName, getL10nDescription: getL10nDescription);

  @override
  void setValue(String sourceString) => value = getEnumFromString(NetworkType.values, sourceString);
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
      SettingsType.USER_NAME: StringSettingData(
        defaultValue: "anonymous",
        getL10nName: (context) => S.of(context).settingsInfo_userName_name,
        getL10nDescription: (context) => S.of(context).settingsInfo_userName_description,
      ),
      SettingsType.USER_PWD: StringSettingData(
        defaultValue: "",
        getL10nName: (context) => S.of(context).settingsInfo_userPassword_name,
        getL10nDescription: (context) => S.of(context).settingsInfo_userPassword_description,
      ),

      SettingsType.USE_DARK_THEME: BooleanSettingData(
        defaultValue: false,
        getL10nName: (context) => S.of(context).settingsInfo_useDarkTheme_name,
        getL10nDescription: (context) => S.of(context).settingsInfo_useDarkTheme_description,
      ),
      SettingsType.HIDE_TOP_BAR: BooleanSettingData(
        defaultValue: true,
        getL10nName: (context) => S.of(context).settingsInfo_hideTopBar_name,
        getL10nDescription: (context) => S.of(context).settingsInfo_hideTopBar_description,
      ),
      SettingsType.HIDE_HOME_KEY: BooleanSettingData(
        defaultValue: true,
        getL10nName: (context) => S.of(context).settingsInfo_hideHomeKey_name,
        getL10nDescription: (context) => S.of(context).settingsInfo_hideHomeKey_description,
      ),
      SettingsType.USE_VIBRATION: BooleanSettingData(
        defaultValue: true,
        getL10nName: (context) => S.of(context).settingsInfo_useVibration_name,
        getL10nDescription: (context) => S.of(context).settingsInfo_useVibration_description,
      ),

      SettingsType.NETWORK_TYPE: NetworkTypeSettingData(
        defaultValue: NetworkType.WIFI,
        getL10nName: (context) => S.of(context).settingsInfo_networkType_name,
        getL10nDescription: (context) => S.of(context).settingsInfo_networkType_description,
      ),
      SettingsType.NETWORK_TIMEOUT: IntegerSettingData(
        defaultValue: 1500,
        getL10nName: (context) => S.of(context).settingsInfo_networkTimeOut_name,
        getL10nDescription: (context) => S.of(context).settingsInfo_networkTimeOut_description,
      ),
      SettingsType.AUTO_CONNECTION: BooleanSettingData(
        defaultValue: true,
        getL10nName: (context) => S.of(context).settingsInfo_autoReconnection_name,
        getL10nDescription: (context) => S.of(context).settingsInfo_autoReconnection_description,
      ),
    };
  }

}
