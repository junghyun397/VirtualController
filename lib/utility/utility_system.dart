import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SystemUtility {
  
  static late Size _fullScreenSize;
  static set physicalSize(Size screenSize) {
    if (screenSize.height > screenSize.width) screenSize = Size(screenSize.height, screenSize.width);
    if (_fullScreenSize.height < screenSize.height || _fullScreenSize.width < screenSize.width)
      _fullScreenSize = screenSize;
  }
  static Size get physicalSize => _fullScreenSize;

  static Future<void> enableUIOverlays(bool hideTop, bool hideBottom) async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      if (!hideBottom) SystemUiOverlay.bottom,
      if (!hideTop) SystemUiOverlay.top,
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

  static void showToast(String message, {Color backgroundColor = Colors.white}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: backgroundColor == Colors.white ? Colors.black : Colors.white,
      fontSize: 16.0,
    );

  static void vibrate() {
    Vibrate.feedback(FeedbackType.success);
  }

}