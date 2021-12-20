import 'dart:async';
import 'dart:ui';

import 'package:vfcs/app.dart';
import 'package:vfcs/app_manager.dart';
import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/data/database_provider.dart';
import 'package:vfcs/network/network_manager.dart';
import 'package:vfcs/panel/panel_manager.dart';
import 'package:vfcs/utility/utility_dart.dart';
import 'package:vfcs/utility/utility_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

Future<AppManager> initializeAppManager() async {
  final DatabaseProvider databaseProvider = DatabaseProvider();
  await databaseProvider.initializeDb();
  
  final SettingsProvider settingsProvider = SettingsProvider(databaseProvider);
  settingsProvider.loadSavedSettings();
  
  final PanelManager panelManager = PanelManager(databaseProvider);
  await panelManager.loadSavedPanelList();

  final NetworkManager networkManager = NetworkManager
      .fromNetworkType(settingsProvider.getSettingData(SettingType.NETWORK_TYPE).value, settingsProvider, databaseProvider);
  networkManager.startNotifyNetworkConditionToast();
  networkManager.tryAutoReconnection();

  return AppManager(databaseProvider, settingsProvider, networkManager, panelManager);
}

Future<void> initializeUX(SettingsProvider settingsProvider) async {
  SystemUtility.physicalSize =
      Size(window.physicalSize.width / window.devicePixelRatio, window.physicalSize.height / window.devicePixelRatio);

  SystemUtility.preferredUIOverlays = Pair(settingsProvider.getSettingData(SettingType.HIDE_TOP_BAR).value,
      settingsProvider.getSettingData(SettingType.HIDE_HOME_KEY).value);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  if (settingsProvider.getSettingData(SettingType.USE_WAKE_LOCK).value) Wakelock.enable();
  else Wakelock.disable();

  await SystemUtility.enforceUIOverlays(Right(Pair(
      settingsProvider.getSettingData(SettingType.HIDE_HOME_KEY).value,
      settingsProvider.getSettingData(SettingType.HIDE_TOP_BAR).value
  )));
}

void main() async {
  final AppManager appManager = await initializeAppManager();
  await initializeUX(appManager.settingProvider);

  WidgetsFlutterBinding.ensureInitialized();
  runApp(VFCSApp(appManager));
}