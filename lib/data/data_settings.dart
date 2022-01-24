import 'package:flutter/widgets.dart';
import 'package:vfcs/data/database_provider.dart';
import 'package:vfcs/generated/l10n.dart';
import 'package:vfcs/utility/disposable.dart';
import 'package:vfcs/utility/utility_dart.dart';

abstract class SettingData<T> {
  late T value;
  final T defaultValue;
  
  final String Function(BuildContext) getL10nName;
  final String Function(BuildContext) getL10nDescription;

  SettingData(
    this.defaultValue,
    this.getL10nName,
    this.getL10nDescription,
  ) {
    this.value = this.defaultValue;
  }

  void setValue(String sourceString);

  @override
  String toString() {
    return value.toString();
  }
}

class StringSettingData extends SettingData<String> {
  StringSettingData(String defaultValue, String Function(BuildContext) getL10nName, String Function(BuildContext) getL10nDescription):
        super(defaultValue, getL10nName, getL10nDescription);

  @override
  void setValue(String sourceString) => value = sourceString;
}

class BooleanSettingData extends SettingData<bool> {
  BooleanSettingData(bool defaultValue, String Function(BuildContext) getL10nName, String Function(BuildContext) getL10nDescription):
        super(defaultValue, getL10nName, getL10nDescription);

  @override
  void setValue(String sourceString) => value = sourceString.toLowerCase() == "true" ? true : false;
}

class IntegerSettingData extends SettingData<int> {
  IntegerSettingData(int defaultValue, String Function(BuildContext) getL10nName, String Function(BuildContext) getL10nDescription):
        super(defaultValue, getL10nName, getL10nDescription);

  @override
  void setValue(String sourceString) => value = int.parse(sourceString);
}

enum NetworkType {WEB_SOCKET, BLUETOOTH, USB_SERIAL}

class NetworkTypeSettingData extends SettingData<NetworkType> {
  NetworkTypeSettingData(NetworkType defaultValue, String Function(BuildContext) getL10nName, String Function(BuildContext) getL10nDescription) :
        super(defaultValue, getL10nName, getL10nDescription);

  @override
  void setValue(String sourceString) => value = getEnumFromString(NetworkType.values, sourceString);
}

enum SettingType {
  USER_NAME,
  USER_PASSWORD,

  ENFORCE_DARK_THEME,
  HIDE_TOP_BAR,
  HIDE_HOME_KEY,

  NETWORK_TYPE,
  NETWORK_TIMEOUT,
  AUTO_CONNECTION,

  USE_VIBRATION,
  USE_WAKE_LOCK,

  USE_BACKGROUND_TITLE,
}

class SettingsProvider implements Disposable {

  final DatabaseProvider databaseProvider;

  final Map<SettingType, SettingData> _settingsMap = _buildDefaultSettings();

  SettingsProvider(this.databaseProvider);

  void resetGlobalSettings() {
    this._settingsMap.clear();
    this._settingsMap.addAll(_buildDefaultSettings());
    this._settingsMap.forEach((key, val) => this.databaseProvider.insertSettings(key, val));
  }

  void loadSavedSettings() =>
      this.databaseProvider.getSavedSettingsValue().forEach((key, value) => this._settingsMap[key]!.setValue(value));

  SettingData getSettingData(SettingType settingsType) =>
      this._settingsMap[settingsType]!;

  static Map<SettingType, SettingData> _buildDefaultSettings() {
    return {
      SettingType.USER_NAME: StringSettingData(
        "anonymous",
        (context) => S.of(context).settingsInfo_userName_name,
        (context) => S.of(context).settingsInfo_userName_description,
      ),
      SettingType.USER_PASSWORD: StringSettingData(
        "",
        (context) => S.of(context).settingsInfo_userPassword_name,
        (context) => S.of(context).settingsInfo_userPassword_description,
      ),

      SettingType.ENFORCE_DARK_THEME: BooleanSettingData(
        false,
        (context) => S.of(context).settingsInfo_useDarkTheme_name,
        (context) => S.of(context).settingsInfo_useDarkTheme_description,
      ),
      SettingType.HIDE_TOP_BAR: BooleanSettingData(
        true,
        (context) => S.of(context).settingsInfo_hideTopBar_name,
        (context) => S.of(context).settingsInfo_hideTopBar_description,
      ),
      SettingType.HIDE_HOME_KEY: BooleanSettingData(
        true,
        (context) => S.of(context).settingsInfo_hideHomeKey_name,
        (context) => S.of(context).settingsInfo_hideHomeKey_description,
      ),
      SettingType.USE_VIBRATION: BooleanSettingData(
        true,
        (context) => S.of(context).settingsInfo_useVibration_name,
        (context) => S.of(context).settingsInfo_useVibration_description,
      ),
      SettingType.USE_WAKE_LOCK: BooleanSettingData(
        true,
        (context) => S.of(context).settingsInfo_useWakeLock_name,
        (context) => S.of(context).settingsInfo_useWakeLock_description,
      ),

      SettingType.NETWORK_TYPE: NetworkTypeSettingData(
        NetworkType.WEB_SOCKET,
        (context) => S.of(context).settingsInfo_networkType_name,
        (context) => S.of(context).settingsInfo_networkType_description,
      ),
      SettingType.NETWORK_TIMEOUT: IntegerSettingData(
        1500,
        (context) => S.of(context).settingsInfo_networkTimeOut_name,
        (context) => S.of(context).settingsInfo_networkTimeOut_description,
      ),
      SettingType.AUTO_CONNECTION: BooleanSettingData(
        true,
        (context) => S.of(context).settingsInfo_autoReconnection_name,
        (context) => S.of(context).settingsInfo_autoReconnection_description,
      ),
      SettingType.USE_BACKGROUND_TITLE: BooleanSettingData(
        true,
        (context) => S.of(context).settingsInfo_useBackgroundTitle_name,
        (context) => S.of(context).settingsInfo_useBackgroundTitle_description,
      )
    };
  }
  
  @override
  void dispose() {}

}
