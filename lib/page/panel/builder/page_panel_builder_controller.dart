import 'dart:convert';
import 'dart:math';

import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum SelectableTileState {
  USED,
  USABLE,
  SELECTED,
}

class PagePanelBuilderController with ChangeNotifier {

  final PanelSetting panelSetting;

  bool isSelectionMode = false;
  ComponentType selectedComponent;
  List<List<SelectableTileState>> componentPositionMap;

  Pair<int, int> firstPoint;

  PagePanelBuilderController(this.panelSetting);

  void choiceComponent(ComponentType componentType) {
    this.isSelectionMode = true;
    this.selectedComponent = componentType;
    this.componentPositionMap = List.generate(panelSetting.width, (_) =>
        List.filled(panelSetting.height, SelectableTileState.USABLE));
    this.panelSetting.components.forEach((key, val) {
      for (int w = 0; w < val.width; w++) for (int h = 0; h < val.height; h++)
        this.componentPositionMap[val.x + w][val.y + h] = SelectableTileState.USED;
    });
    notifyListeners();
  }

  void selectArea(Pair<int, int> position) {
    if (this.firstPoint == null) {
      this.componentPositionMap[position.a][position.b]  = SelectableTileState.SELECTED;
      this.firstPoint = position;
    }
    else {
      int x = min(this.firstPoint.a, position.a);
      int y = min(this.firstPoint.b, position.b);
      int width = (this.firstPoint.a - position.a).abs() + 1;
      int height = (this.firstPoint.b - position.b).abs() + 1;
      if (!this.checkComponentSize(width, height)) {
        SystemUtility.showToast(message: "The selected area is smaller than the minimum size required by component.");
        return;
      }
      else if (!this.checkComponentPosition(x, y, width, height)) return;
      this.firstPoint = null;
      this.insertComponent(getDefaultComponentSetting(this.selectedComponent,
          name: PanelUtility.findNewName(this.panelSetting, this.selectedComponent),
          x: x, y: y, width: width, height: height,
          targetInputs: PanelUtility.findTargetInput(this.panelSetting, this.selectedComponent)),
      );
    }
    notifyListeners();
  }

  bool checkComponentSize(int width, int height) =>
      width >= COMPONENT_DEFINITION[this.selectedComponent].minWidth
          && height >= COMPONENT_DEFINITION[this.selectedComponent].minHeight;

  bool checkComponentPosition(int x, int y, int width, int height) {
    for (int w = x; w < width + x; w++) for (int h = y; h < height + y; h++) {
      if (this.componentPositionMap[w][h] == SelectableTileState.USED) return false;
    }
    return true;
  }

  bool checkComponentName(String componentName) => !this.panelSetting.components.containsKey(componentName);

  void insertComponent(ComponentSetting componentSetting) {
    this.isSelectionMode = false;
    this.selectedComponent = null;
    this.panelSetting.components[componentSetting.name] = componentSetting;
    this.componentPositionMap = null;
    AppPanelManager().updatePanel(this.panelSetting);
    notifyListeners();
  }

  void updateComponent() {
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
    SystemUtility.showToast(message: "Copied to clipboard.");
  }

}