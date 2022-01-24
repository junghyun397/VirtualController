import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vfcs/panel/component/component_theme.dart';

@immutable
class PanelThemeData with Diagnosticable {

  final ComponentThemeData componentThemeData;

  final Color backgroundColor;
  final Color backgroundTitleColor;

  final Color couplingConnectedColor;
  final Color couplingGreyColor;

  final Color fabBackgroundColor;
  final Color fabForegroundColor;

  const PanelThemeData({
    required this.componentThemeData,

    required this.backgroundColor,
    required this.backgroundTitleColor,

    required this.couplingConnectedColor,
    required this.couplingGreyColor,

    required this.fabBackgroundColor,
    required this.fabForegroundColor
  });

  static const PanelThemeData defaultData = PanelThemeData(
    componentThemeData: ComponentThemeData.defaultData,

    backgroundColor: Color.fromRGBO(35, 36, 35, 1),
    backgroundTitleColor: Colors.black26,

    couplingConnectedColor: Colors.green,
    couplingGreyColor: Colors.grey,

    fabBackgroundColor: Colors.white,
    fabForegroundColor: Colors.black,
  );

}

class PanelTheme extends InheritedTheme {

  final PanelThemeData themeData;

  PanelTheme({
    Key? key,
    required Widget child,
    required this.themeData,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant PanelTheme oldWidget) => this.themeData != oldWidget.themeData;

  @override
  Widget wrap(BuildContext context, Widget child) => PanelTheme(child: child, themeData: this.themeData);

  static PanelThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PanelTheme>()?.themeData ?? PanelThemeData.defaultData;

}