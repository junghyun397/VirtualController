import 'package:flutter/services.dart';

class UtilitySystem {

  static void enableUIOverlays(bool enable) {
    if (enable) SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    else SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    // else SystemChrome.setEnabledSystemUIOverlays([]); // TODO: find solution remove to safeArea
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