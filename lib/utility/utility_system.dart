import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vfcs/utility/utility_dart.dart';

class SystemUtility {
  
  static late Size _fullScreenSize;
  static set physicalSize(Size screenSize) {
    if (screenSize.height > screenSize.width) screenSize = screenSize.flipped;
    if (_fullScreenSize.height < screenSize.height || _fullScreenSize.width < screenSize.width)
      _fullScreenSize = screenSize;
  }
  static Size get physicalSize => _fullScreenSize;

  static late Pair<bool, bool> preferredUIOverlays;

  static Future<void> enforceUIOverlays(Either<bool, Pair<bool, bool>> option) async =>
      option.fold(
          onLeft: (left) async => await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive),
          onRight: (right) async => await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
            if (!right.a) SystemUiOverlay.bottom,
            if (!right.b) SystemUiOverlay.top,
          ]),
      );

  static void enforceOrientation(bool enable, {Orientation? orientation}) =>
    SystemChrome.setPreferredOrientations([
      if (!enable || orientation == Orientation.landscape) DeviceOrientation.landscapeRight,
      if (!enable || orientation == Orientation.landscape) DeviceOrientation.landscapeLeft,
      if (!enable || orientation == Orientation.portrait) DeviceOrientation.portraitUp,
      if (!enable || orientation == Orientation.portrait) DeviceOrientation.portraitDown,
    ]);

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

  static void vibrate() => Vibrate.feedback(FeedbackType.success);

}