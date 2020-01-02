class SettingPiece<T> {
  T value;
  T defaultValue;

  String settingName;
  String description;

  SettingPiece({
    T defaultValue,
    String settingName, String description}) {

    this.defaultValue = defaultValue;
    this.value = defaultValue;
    this.settingName = settingName;
    this.description = description;
  }

  void saveValue(T value) {
    // TODO: connect DB
    this.value = value;
  }

  @override
  String toString() {
    return value.toString();
  }
}

enum SettingsType {
  USER_NAME,
  USER_PWD,
  HIDE_TOP_BAR,
  HIDE_HOME_KEY,
  AUTO_CONNECTION
}

class GlobalSettings {

  static Map<SettingsType, SettingPiece> _buildDefaultSettings() {
    return {
      SettingsType.USER_NAME: new SettingPiece<String>(
        defaultValue: "anonymous",
        settingName: "User name",
        description: "user name",
      ), // TODO: i8n needed
      SettingsType.USER_PWD: new SettingPiece<String>(
        defaultValue: "",
        settingName: "User password",
        description: "user password",
      ),

      SettingsType.HIDE_TOP_BAR: new SettingPiece<bool>(
        defaultValue: true,
        settingName: "Hide topbar",
        description: "enable automatic hide top-bar option",
      ),
      SettingsType.HIDE_HOME_KEY: new SettingPiece<bool>(
        defaultValue: false,
        settingName: "Hide homekey",
        description: "enable automatic hide home-key option",
      ),

      SettingsType.AUTO_CONNECTION: new SettingPiece<bool>(
        defaultValue: true,
        settingName: "Auto connection",
        description: "enable auto connection",
      ),
    };
  }

  static Map<SettingsType, SettingPiece> settingsMap = _buildDefaultSettings();

  static void initializeGlobalSettings() {
    // TODO: connection SQL-Lite-3 DataBase
  }

  static void resetGlobalSettings() {
    settingsMap = _buildDefaultSettings();
  }

}
