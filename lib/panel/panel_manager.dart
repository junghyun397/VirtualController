import 'dart:ui';

import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';

class PanelUtility {
  static const double MIN_BLOCK_WIDTH = 75.0;
  static const double MIN_BLOCK_HEIGHT = 100.0;

  static const double TOP_MARGIN = 20;

  static bool canBuildPanelPerfectly(PanelSetting panelSetting, Size screenSize) =>
      screenSize.width / panelSetting.width < MIN_BLOCK_WIDTH || (screenSize.height - TOP_MARGIN) / panelSetting.height < MIN_BLOCK_HEIGHT;

  static Pair<int, int> getMaxPanelSize(Size screenSize) =>
      Pair(screenSize.width ~/ MIN_BLOCK_WIDTH, screenSize.height ~/ MIN_BLOCK_HEIGHT);

  static Size getBlockSize(PanelSetting panelSetting, Size screenSize) =>
      Size(screenSize.width / panelSetting.width, (screenSize.height - TOP_MARGIN) / panelSetting.height);

}

class AppPanelManager {
  static final AppPanelManager _singleton = new AppPanelManager._internal();
  factory AppPanelManager() =>  _singleton;
  AppPanelManager._internal();

  List<PanelSetting> panelList = List<PanelSetting>();

  Future<void> loadSavedPanelSettings() async {
    return Future.value();
  }

}
