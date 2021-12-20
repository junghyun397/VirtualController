import 'package:flutter/material.dart';

class PanelColors {

  static const Color background = Color.fromRGBO(35, 36, 35, 1);
  static const Color backgroundTitle = Colors.black26;

  static const Color component = Color.fromRGBO(124, 124, 124, 1);
  static const Color border = Color.fromRGBO(0, 0, 0, 1);

  static const Color connected = Colors.green;
  static const Color grey = Colors.grey;

  static const Color fabBackground = Colors.white;
  static const Color fabForeground = Colors.black;

}

class DefaultThemeColors {

  static const Color background = Color.fromRGBO(255, 255, 255, 1);
  static const Color entry = Color.fromRGBO(255, 255, 255, 1);

  static const Color primary = Color.fromRGBO(30, 30, 30, 1);
  static const Color secondary = Color.fromRGBO(108, 108, 108, 1);

  static const Color content = Color.fromRGBO(31, 31, 31, 1);

  static const Color warning = Color.fromRGBO(215, 60, 0, 1);
  static const Color link = Color.fromRGBO(0, 122, 255, 1);

}

class DarkDefaultThemeColors {

  static const Color background = Color.fromRGBO(29, 30, 32, 1);
  static const Color entry = Color.fromRGBO(46, 46, 51, 1);

  static const Color primary  = Color.fromRGBO(218, 218, 219, 1);
  static const Color secondary = Color.fromRGBO(155, 156, 157, 1);

  static const Color content = Color.fromRGBO(195, 195, 196, 1);

  static const Color warning = Color.fromRGBO(255, 94, 84, 1);
  static const Color link = Color.fromRGBO(84, 130, 255, 1);

}

class MaterialTemplate {

  late Color primary;
  late Color onPrimary;

  late Color primaryContainer;
  late Color onPrimaryContainer;

  late Color secondary;
  late Color onSecondary;

  late Color secondaryContainer;
  late Color onSecondaryContainer;

  late Color tertiary;
  late Color onTertiary;

  late Color tertiaryContainer;
  late Color onTertiaryContainer;

  late Color error;
  late Color onError;

  late Color errorContainer;
  late Color onErrorContainer;

  late Color background;
  late Color onBackground;

  late Color surface;
  late Color onSurface;

  late Color surfaceVariant;
  late Color onSurfaceVariant;

  late Color outline;

}

ThemeData defaultAppTheme = ThemeData.from(
    colorScheme: const ColorScheme.light(
      primary: DefaultThemeColors.background,
      primaryVariant: DefaultThemeColors.background,
      onPrimary: DefaultThemeColors.primary,

      secondary: DefaultThemeColors.entry,
      secondaryVariant: DefaultThemeColors.entry,
      onSecondary: DefaultThemeColors.primary,

      surface: DefaultThemeColors.entry,
      onSurface: DefaultThemeColors.primary,

      background: DefaultThemeColors.background,
      onBackground: DefaultThemeColors.secondary,

      error: DefaultThemeColors.warning,
      onError: DefaultThemeColors.primary,
    ));

ThemeData darkDefaultAppTheme = ThemeData.from(
    colorScheme: const ColorScheme.dark(
      primary: DarkDefaultThemeColors.background,
      primaryVariant: DarkDefaultThemeColors.background,
      onPrimary: DarkDefaultThemeColors.primary,

      secondary: DarkDefaultThemeColors.entry,
      secondaryVariant: DarkDefaultThemeColors.entry,
      onSecondary: DefaultThemeColors.primary,

      surface: DarkDefaultThemeColors.entry,
      onSurface: DarkDefaultThemeColors.primary,

      background: DarkDefaultThemeColors.background,
      onBackground: DarkDefaultThemeColors.secondary,

      error: DarkDefaultThemeColors.warning,
      onError: DarkDefaultThemeColors.primary,
    ));
