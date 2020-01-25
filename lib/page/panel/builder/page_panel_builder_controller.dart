import 'dart:convert';

import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PagePanelBuilderController with ChangeNotifier {

  final PanelSetting panelSetting;

  bool isSelectionMode = false;

  PagePanelBuilderController(this.panelSetting);

  void switchSelectionMode() {
    this.isSelectionMode = true;
    notifyListeners();
  }

  bool checkComponentName(String componentName) => this.panelSetting.components.containsKey(componentName);

  bool checkComponentPosition(int x, int y, int width, int height) {
    for (int nx = x; nx < width; nx++) for (int ny = y; ny < height; ny++);
    this.panelSetting.components.forEach((key, val) {
    });
  }

  void addComponent(String componentName, ComponentSetting componentSetting) {
    this.panelSetting.components[componentName] = componentSetting;
    this.savePanel();
    notifyListeners();
  }

  void savePanel() {
    AppPanelManager().savePanel(this.panelSetting);
    Fluttertoast.showToast(
      msg: "Panel saved.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }

  void copyPanelToClipboard() {
    Clipboard.setData(ClipboardData(text: jsonEncode(this.panelSetting.toJSON())));
    Fluttertoast.showToast(
      msg: "Copied to clipboard.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }

}