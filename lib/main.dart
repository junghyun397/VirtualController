import 'dart:async';
import 'dart:ui';

import 'package:vfcs/app_manager.dart';
import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/data/database_provider.dart';
import 'package:vfcs/network/network_manager.dart';
import 'package:vfcs/panel/panel_manager.dart';
import 'package:vfcs/routes.dart';
import 'package:vfcs/utility/utility_system.dart';
import 'package:vfcs/utility/utility_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'generated/l10n.dart';
import 'page/direction_state.dart';

class VirtualThrottleApp extends StatelessWidget {

  final AppManager appManager;

  VirtualThrottleApp(this.appManager);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppManager>(
      create: (_) => this.appManager,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "VFCS",
        theme: ThemeData(primarySwatch: primaryBlack),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        themeMode: this.appManager.settingManager.getSettingData(SettingType.USE_DARK_THEME).value
            ? ThemeMode.dark
            : ThemeMode.system,

        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,

        initialRoute: Routes.PAGE_MAIN_PANEL,
        routes: Routes.routes,
        navigatorObservers: [routeObserver],
      ),
    );
  }

}

Future<AppManager> initializeAppManager() async {
  final SQLite3Provider sqLite3Manager = SQLite3Provider();
  await sqLite3Manager.initializeDb();
  
  final SettingManager settingManager = SettingManager(sqLite3Manager);
  await settingManager.loadSavedSettings();
  
  final PanelManager panelManager = PanelManager(sqLite3Manager);
  await panelManager.loadSavedPanelList();

  final NetworkManager networkManager = NetworkManager
      .fromNetworkType(settingManager.getSettingData(SettingType.NETWORK_TYPE).value, settingManager, sqLite3Manager);
  networkManager.startNotifyNetworkConditionToast();
  networkManager.tryAutoReconnection();

  return Future.value(AppManager(sqLite3Manager, settingManager, networkManager, panelManager));
}

Future<void> initializeUX(SettingManager settingManager) async {
  SystemUtility.physicalSize =
      Size(window.physicalSize.width / window.devicePixelRatio, window.physicalSize.height / window.devicePixelRatio);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  if (settingManager.getSettingData(SettingType.USE_WAKE_LOCK).value) Wakelock.enable();
  else Wakelock.disable();

  await SystemUtility.enableUIOverlays(
      settingManager.getSettingData(SettingType.HIDE_HOME_KEY).value,
      settingManager.getSettingData(SettingType.HIDE_TOP_BAR).value
  );
}

void main() async {
  final AppManager appManager = await initializeAppManager();
  await initializeUX(appManager.settingManager);

  WidgetsFlutterBinding.ensureInitialized();
  runApp(VirtualThrottleApp(appManager));
}