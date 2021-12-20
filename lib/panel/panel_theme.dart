import 'package:flutter/material.dart';

class PanelTheme {

  final Color backgroundColor = const Color.fromRGBO(35, 36, 35, 1);
  final Color backgroundTitleColor = Colors.black26;

  final Color couplingConnectedColor = Colors.green;
  final Color couplingGreyColor = Colors.grey;

  final Color fabBackgroundColor = Colors.white;
  final Color fabForegroundColor = Colors.black;

  const PanelTheme();

}

extension CustomThemeData on ThemeData {
  
  PanelTheme get panelTheme => const PanelTheme();
  
}