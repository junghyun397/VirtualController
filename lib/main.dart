import 'dart:ui';

import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:VirtualFlightThrottle/network/network_manager.dart';
import 'package:VirtualFlightThrottle/page/panel/builder/page_panel_builder.dart';
import 'package:VirtualFlightThrottle/page/panel/list/page_panel_list.dart';
import 'package:VirtualFlightThrottle/page/panel/store/page_panel_store.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/routes.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:VirtualFlightThrottle/utility/utility_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'page/direction_state.dart';
import 'page/main/page_main_panel.dart';
import 'page/network/page_network.dart';
import 'page/settings/page_settings.dart';

class VirtualThrottleApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    S.delegate.supportedLocales.forEach((val) => print(val.countryCode));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "VFT Flight Throttle",
      theme: ThemeData(
        primarySwatch: primaryBlack,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      themeMode: AppSettings().settingsMap[SettingsType.USE_DARK_THEME].value
          ? ThemeMode.dark
          : ThemeMode.system,

      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,

      initialRoute: "/",
      routes: {
        Routes.PAGE_MAIN_PANEL: (context) => PageMainPanel(),
        Routes.PAGE_PANEL_LIST: (context) => PagePanelList(),
        Routes.PAGE_PANEL_BUILDER: (context) => PagePanelBuilder(),
        Routes.PAGE_PANEL_STORE: (context) => PagePanelStore(),
        Routes.PAGE_NETWORK: (context) => PageNetwork(),
        Routes.PAGE_SETTING: (context) => PageSettings(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}

Future<void> initializeGlobalComponent() async {
  await SystemChrome.setEnabledSystemUIOverlays([]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  UtilitySystem.fullScreenSize =
      Size(window.physicalSize.width / window.devicePixelRatio, window.physicalSize.height / window.devicePixelRatio);
  await SQLite3Helper().initializeDb();
  await AppSettings().loadSavedGlobalSettings();
  await AppPanelManager().loadSavedPanelList();
  AppNetworkManager().startNotifyNetworkStateToast();
  AppNetworkManager().tryAutoReconnection();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeGlobalComponent();
  runApp(VirtualThrottleApp());
}
