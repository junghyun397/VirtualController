class SettingPiece<T> {
  T value;
  T defaultValue;

  String settingName;
  String description;

  SettingPiece({
    T defaultValue,
    String settingName, String description}) {

    this.value = defaultValue;
    this.defaultValue = defaultValue;
    this.settingName = settingName;
    this.description = description;
  }

  @override
  String toString() {
    return value.toString();
  }
}

class GlobalSettings {

  static Map<String, SettingPiece> _buildDefaultSettings() {
    return {
      "user-name": new SettingPiece<String>(
        defaultValue: "anonymous",
        settingName: "User name",
        description: "user name",
      ), // TODO: i8n needed
      "user-pwd": new SettingPiece<String>(
        defaultValue: "",
        settingName: "User password",
        description: "user password",
      ),

      "hide-top-bar": new SettingPiece<bool>(
        defaultValue: true,
        settingName: "Hide topbar",
        description: "enable automatic hide top-bar option",
      ),
      "hide-home-key": new SettingPiece<bool>(
        defaultValue: false,
        settingName: "Hide homekey",
        description: "enable automatic hide home-key option",
      ),

      "auto-connection": new SettingPiece<bool>(
        defaultValue: true,
        settingName: "Auto connection",
        description: "enable auto connection",
      ),
    };
  }

  static Map<String, SettingPiece> settingsMap = _buildDefaultSettings();

  static void initializeGlobalSettings() {
    // TODO: connection SQL-Lite-3 DataBase
  }

  static void resetGlobalSettings() {
    settingsMap = _buildDefaultSettings();
  }

}
