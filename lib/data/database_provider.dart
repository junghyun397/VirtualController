import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/panel/panel_data.dart';
import 'package:vfcs/utility/disposable.dart';
import 'package:vfcs/utility/utility_dart.dart';

class DatabaseProvider implements Disposable {

  static const PANELS_KEY = "panels";
  static const SETTINGS_KEY = "settings";
  static const REGISTERED_SERVERS_KEY = "registered_servers";
  static const INTRO_KEY = "intro";

  late final Map<String, PanelData> _panels;
  late final Map<SettingType, String> _settings;
  late final List<String> _registeredServers;
  late bool _intro;

  Future<void> initializeDb() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final Map<String, PanelData> panels;
    if (!sharedPreferences.containsKey(PANELS_KEY)) {
      panels = Map<String, PanelData>();
      await savePanels(panels);
    } else panels = jsonDecode(sharedPreferences.getString(PANELS_KEY)!)
        .map((key, value) => MapEntry(key, PanelData.fromJSON(key, jsonDecode(value))));
    this._panels = panels;

    final Map<SettingType, String> settings;
    if (!sharedPreferences.containsKey(SETTINGS_KEY)) {
      settings = Map<SettingType, String>();
      await saveSettings(settings);
    } else settings = jsonDecode(sharedPreferences.getString(SETTINGS_KEY)!)
        .map((key, value) => MapEntry(getEnumFromString(SettingType.values, key), value));
    this._settings = settings;

    final List<String> registeredServers;
    if (!sharedPreferences.containsKey(REGISTERED_SERVERS_KEY)) {
      registeredServers = List.empty(growable: true);
      await saveRegisteredServers(registeredServers);
    } else registeredServers = sharedPreferences.getStringList(REGISTERED_SERVERS_KEY)!;
    this._registeredServers = registeredServers;

    final watched;
    if (!sharedPreferences.containsKey(INTRO_KEY)) {
      watched = false;
      await saveIntro(watched);
    } else watched = sharedPreferences.getBool(INTRO_KEY);
    this._intro = watched;
  }

  static Future<void> savePanels(Map<String, PanelData> panels) async =>
    (await SharedPreferences.getInstance()).setString(PANELS_KEY, jsonEncode(panels
        .map((key, value) => MapEntry(key, jsonEncode(value.toJSON())))));

  static Future<void> saveSettings(Map<SettingType, String> settings) async =>
    (await SharedPreferences.getInstance()).setString(SETTINGS_KEY, jsonEncode(settings
        .map((key, value) => MapEntry(key.toString(), value))));

  static Future<void> saveRegisteredServers(List<String> registeredServers) async =>
    (await SharedPreferences.getInstance()).setStringList(PANELS_KEY, registeredServers);

  static Future<void> saveIntro(bool watched) async =>
    (await SharedPreferences.getInstance()).setBool(INTRO_KEY, watched);

  Map<SettingType, String> getSavedSettingsValue() => this._settings;

  Future<void> insertSettings(SettingType settingsType, SettingData settingData) async {
    this._settings.update(settingsType, (_) => settingData.toString(), ifAbsent: () => settingData.toString());
    await saveSettings(this._settings);
  }

  Map<String, PanelData> getSavedPanelList() => this._panels;

  Future<void> insertPanel(String panelName, PanelData panelData) async {
    this._panels.update(panelName, (value) => panelData, ifAbsent: () => panelData);
    await savePanels(this._panels);
  }

  Future<void> removePanel(String panelName) async {
    this._panels.remove(panelName);
    await savePanels(this._panels);
  }

  List<String> getSavedRegisteredDevices() => this._registeredServers;

  Future<void> insertRegisteredDevices(String address) async {
    this._registeredServers.add(address);
    await saveRegisteredServers(this._registeredServers);
  }

  bool getIntroWatched() => this._intro;

  Future<void> setIntroWatched() async {
    this._intro = true;
    await saveIntro(true);
  }

  @override
  void dispose() {}

}