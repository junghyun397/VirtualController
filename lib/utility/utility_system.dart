import 'package:VirtualFlightThrottle/data/data_global_settings.dart';
import 'package:flutter/services.dart';

class UtilitySystem {

  static void enableUIOverlays(bool enable) {
    if (enable) SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    else {
      List<SystemUiOverlay> systemUI = [];
      if (!GlobalSettings.settingsMap["hide-home-key"].value) systemUI.add(SystemUiOverlay.bottom);
      if (!GlobalSettings.settingsMap["hide-top-bar"].value) systemUI.add(SystemUiOverlay.top);
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