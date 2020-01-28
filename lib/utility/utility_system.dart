import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibrate/vibrate.dart';

class UtilitySystem {
  
  static Size _fullScreenSizeCache = Size(0, 0);
  static set fullScreenSize(Size size) {
    if (_fullScreenSizeCache.height < size.height || _fullScreenSizeCache.width < size.width) _fullScreenSizeCache = size;
  }
  static Size get fullScreenSize => _fullScreenSizeCache;

  static Future<void> enableUIOverlays(bool enable) async {
    if (enable) await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    else await SystemChrome.setEnabledSystemUIOverlays([
      if (!AppSettings().settingsMap[SettingsType.HIDE_HOME_KEY].value) SystemUiOverlay.bottom,
      if (!AppSettings().settingsMap[SettingsType.HIDE_TOP_BAR].value) SystemUiOverlay.top,
    ]);
  }

  static void enableFixedDirection(bool enable) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      if (!enable) DeviceOrientation.portraitUp,
      if (!enable) DeviceOrientation.portraitDown,
    ]);
  }

  static void enableDarkSoftKey() =>
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(statusBarIconBrightness: Brightness.light));


  static void vibrate() {
    if (AppSettings().settingsMap[SettingsType.USE_VIBRATION].value) Vibrate.feedback(FeedbackType.success);
  }

}