import 'dart:convert';

import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PagePanelBuilderController with ChangeNotifier {

  final PanelSetting panelSetting;

  bool isSelectionMode = false;
  ComponentType selectedComponent;

  PagePanelBuilderController(this.panelSetting);

  void selectComponent(ComponentType componentType) {
    this.isSelectionMode = true;
    this.selectedComponent = componentType;
    notifyListeners();
  }

  bool checkComponentSize(int width, int height) =>
      width >= COMPONENT_DEFINITION[this.selectedComponent].minWidth
          && height >= COMPONENT_DEFINITION[this.selectedComponent].minHeight;

  bool checkComponentPosition(int x, int y, int width, int height) {
    return false;
  }

  bool checkComponentName(String componentName) => !this.panelSetting.components.containsKey(componentName);

  void addComponent(ComponentSetting componentSetting) {
    this.isSelectionMode = false;
    this.selectedComponent = null;
    this.panelSetting.components[componentSetting.name] = componentSetting;
    AppPanelManager().updatePanel(this.panelSetting);
    notifyListeners();
  }

  void updateComponent(ComponentSetting componentSetting) {
    AppPanelManager().updatePanel(this.panelSetting);
    notifyListeners();
  }

  void removeComponent(String componentName) {
    this.panelSetting.components.remove(componentName);
    AppPanelManager().updatePanel(this.panelSetting);
    notifyListeners();
  }

  void copyPanelJsonToClipboard() {
    Clipboard.setData(ClipboardData(text: jsonEncode(this.panelSetting.toJSON())));
    Fluttertoast.showToast(
      msg: "Copied to clipboard.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }

  void savePanel() {
    AppPanelManager().updatePanel(this.panelSetting);
    Fluttertoast.showToast(
      msg: "Panel saved.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }

}