import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibrate/vibrate.dart';

class SystemUtility {
  
  static Size _fullScreenSizeCache = Size(0, 0);
  static set fullScreenSize(Size screenSize) {
    if (screenSize.height > screenSize.width) screenSize = Size(screenSize.height, screenSize.width);
    if (_fullScreenSizeCache.height < screenSize.height || _fullScreenSizeCache.width < screenSize.width)
      _fullScreenSizeCache = screenSize;
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

  static void showToast({@required String message, Color backgroundColor = Colors.white}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: backgroundColor,
      textColor: backgroundColor == Colors.white ? Colors.black : Colors.white,
      fontSize: 16.0,
    );

  static void vibrate() {
    if (AppSettings().settingsMap[SettingsType.USE_VIBRATION].value) Vibrate.feedback(FeedbackType.success);
  }

}