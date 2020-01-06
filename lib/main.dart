import 'package:flutter/material.dart';

import 'page/controller/page_main_controller.dart';
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
      title: "VirtualThrottle",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),

      // TODO: i8n initialize
      // localizationsDelegates: [S.delegate],
      // supportedLocales: S.delegate.supportedLocales,
      // localeResolutionCallback: S.delegate.resolution(fallback: Locale('en')),

      initialRoute: "/",
      routes: {
        PAGE_MAIN_CONTROLLER_ROUTE: (context) => PageMainController(),
        PAGE_LAYOUT_LIST_ROUTE: (context) => PageLayoutList(),
        PAGE_LAYOUT_BUILDER_ROUTE: (context) => PageLayoutBuilder(),
        PAGE_LAYOUT_STORE_ROUTE: (context) => PageLayoutStore(),
        PAGE_NETWORK_ROUTE: (context) => PageNetwork(),
        PAGE_SETTING_ROUTE: (context) => PageSettings(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}

void main() => runApp(VirtualThrottleApp());
