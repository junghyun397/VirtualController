import 'dart:async';
import 'dart:ui';

import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:VirtualFlightThrottle/network/network_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/routes.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:VirtualFlightThrottle/utility/utility_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wakelock/wakelock.dart';

import 'generated/l10n.dart';
import 'page/direction_state.dart';

class VirtualThrottleApp extends StatelessWidget {

  // ignore: close_sinks
  static final StreamController<void> themeStreamController = StreamController<void>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: themeStreamController.stream,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "VFT Flight Throttle",
          theme: ThemeData(
            textSelectionColor: Colors.black26,
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
          themeMode: AppSettings().settingsMap[SettingsType.USE_DARK_THEME].value ? ThemeMode.dark : ThemeMode.system,

          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,

          initialRoute: Routes.PAGE_MAIN_PANEL,
          routes: Routes.routes,
          navigatorObservers: [routeObserver],
        );
      }
    );
  }
}

Future<void> initializeGlobalModules() async {
  await SystemChrome.setEnabledSystemUIOverlays([]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  Wakelock.toggle(on: AppSettings().settingsMap[SettingsType.USE_WAKE_LOCK].value);

  SystemUtility.fullScreenSize =
      Size(window.physicalSize.width / window.devicePixelRatio, window.physicalSize.height / window.devicePixelRatio);

  await SQLite3Helper().initializeDb();
  await AppSettings().loadSavedGlobalSettings();
  await AppPanelManager().loadSavedPanelList();
  AppNetworkManager().startNotifyNetworkStateToast();
  AppNetworkManager().tryAutoReconnection();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeGlobalModules();
  runApp(VirtualThrottleApp());
}
