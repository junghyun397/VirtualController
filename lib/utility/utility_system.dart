import 'package:VirtualFlightThrottle/data/data_app_settings.dart';
import 'package:flutter/services.dart';

class UtilitySystem {

  static void enableUIOverlays(bool enable) {
    if (enable) SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    else {
      List<SystemUiOverlay> systemUI = [];
      if (!AppSettings().settingsMap[SettingsType.HIDE_HOME_KEY].value) systemUI.add(SystemUiOverlay.bottom);
      if (!AppSettings().settingsMap[SettingsType.HIDE_TOP_BAR].value) systemUI.add(SystemUiOverlay.top);
      SystemChrome.setEnabledSystemUIOverlays(systemUI);
    }
  }

  static void enableFixedDirection(bool enable) {
    if (enable)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    else
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
  }

}