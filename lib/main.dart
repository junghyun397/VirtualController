import 'package:VirtualFlightThrottle/data/data_app_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:VirtualFlightThrottle/network/network_app_manager.dart';
import 'package:VirtualFlightThrottle/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'page/main/page_main_panel.dart';
import 'page/direction_state.dart';
import 'page/layout/builder/page_layout_builder.dart';
import 'page/layout/list/page_layout_list.dart';
import 'page/layout/store/page_layout_store.dart';
import 'page/network/page_network.dart';
import 'page/settings/page_settings.dart';

class VirtualThrottleApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "VirtualThrottle",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      themeMode: AppSettings().settingsMap[SettingsType.USE_DARK_THEME].value
          ? ThemeMode.dark
          : ThemeMode.system,

      // TODO: i8n initialize
      // localizationsDelegates: [S.delegate],
      // supportedLocales: S.delegate.supportedLocales,
      // localeResolutionCallback: S.delegate.resolution(fallback: Locale('en')),

      initialRoute: "/",
      routes: {
        Routes.PAGE_MAIN_PANEL: (context) => PageMainPanel(),
        Routes.PAGE_LAYOUT_LIST: (context) => PageLayoutList(),
        Routes.PAGE_LAYOUT_BUILDER: (context) => PageLayoutBuilder(),
        Routes.PAGE_LAYOUT_STORE: (context) => PageLayoutStore(),
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
  await SQLite3Helper().initializeDb();
  await AppSettings().loadSavedGlobalSettings();
  AppNetworkManager().tryAutoReconnection();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeGlobalComponent();
  runApp(VirtualThrottleApp());
}
