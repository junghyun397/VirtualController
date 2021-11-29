import 'package:vfcs/page/about/page_about_app.dart';
import 'package:vfcs/page/main/page_main_panel.dart';
import 'package:vfcs/page/network/page_network.dart';
import 'package:vfcs/page/panel/builder/page_panel_builder.dart';
import 'package:vfcs/page/panel/list/page_panel_list.dart';
import 'package:vfcs/page/settings/page_settings.dart';
import 'package:flutter/material.dart';

class Routes {

  static const String PAGE_MAIN_PANEL = "/";

  static const String PAGE_PANEL_LIST = "/panel";
  static const String PAGE_PANEL_BUILDER = "/panel/builder";

  static const String PAGE_SETTING = "/settings";

  static const String PAGE_NETWORK = "/network";

  static const String PAGE_ABOUT = "/about";

  static final Map<String, Widget Function(BuildContext)> routes =  {
    Routes.PAGE_MAIN_PANEL: (context) => PageMainPanel(),
    Routes.PAGE_PANEL_LIST: (context) => PagePanelList(),
    Routes.PAGE_PANEL_BUILDER: (context) => PagePanelBuilder(),
    Routes.PAGE_NETWORK: (context) => PageNetwork(),
    Routes.PAGE_SETTING: (context) => PageSettings(),
    Routes.PAGE_ABOUT: (context) => PageAboutApp(),
  };

}