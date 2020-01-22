import 'dart:convert';

import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/panel.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';

var testComponentsPanel = PanelSetting.fromJSON("panel", {
  "width": 9,
  "height": 4,
  "components": {
    "slider1": getDefaultComponentSetting(ComponentType.SLIDER, x: 0, y: 0, width: 1, height: 4, targetInputs: [0]).toJSON(),
    "slider2": getDefaultComponentSetting(ComponentType.SLIDER, x: 1, y: 0, width: 1, height: 4, targetInputs: [1], inserts: {
      ComponentSettingType.SLIDER_USE_INTEGER_RANGE: "true",
    }).toJSON(),
    "slider3": getDefaultComponentSetting(ComponentType.SLIDER, x: 2, y: 0, width: 1, height: 4, targetInputs: [2], inserts: {
      ComponentSettingType.SLIDER_DETENT_POINTS: "[10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0]",
    }).toJSON(),

    "toggle switch1": getDefaultComponentSetting(ComponentType.TOGGLE_SWITCH, x: 3, y: 0, width: 1, height: 1, targetInputs: [10, 11]).toJSON(),
    "toggle switch2": getDefaultComponentSetting(ComponentType.TOGGLE_SWITCH, x: 3, y: 1, width: 1, height: 1, targetInputs: [12, 13]).toJSON(),
    "toggle switch3": getDefaultComponentSetting(ComponentType.TOGGLE_SWITCH, x: 3, y: 2, width: 1, height: 1, targetInputs: [14, 15]).toJSON(),
    "toggle switch4": getDefaultComponentSetting(ComponentType.TOGGLE_SWITCH, x: 3, y: 3, width: 1, height: 1, targetInputs: [16, 17]).toJSON(),

    "button1": getDefaultComponentSetting(ComponentType.BUTTON, x: 4, y: 0, width: 1, height: 1, targetInputs: [18]).toJSON(),
    "button2": getDefaultComponentSetting(ComponentType.BUTTON, x: 5, y: 0, width: 1, height: 1, targetInputs: [19]).toJSON(),
    "button3": getDefaultComponentSetting(ComponentType.BUTTON, x: 6, y: 0, width: 1, height: 1, targetInputs: [20]).toJSON(),
    "button4": getDefaultComponentSetting(ComponentType.BUTTON, x: 7, y: 0, width: 1, height: 1, targetInputs: [21]).toJSON(),

    "toggle button1": getDefaultComponentSetting(ComponentType.TOGGLE_BUTTON, x: 4, y: 1, width: 1, height: 1, targetInputs: [22]).toJSON(),
    "toggle button2": getDefaultComponentSetting(ComponentType.TOGGLE_BUTTON, x: 5, y: 1, width: 1, height: 1, targetInputs: [23]).toJSON(),
    "toggle button3": getDefaultComponentSetting(ComponentType.TOGGLE_BUTTON, x: 6, y: 1, width: 1, height: 1, targetInputs: [24]).toJSON(),
    "toggle button4": getDefaultComponentSetting(ComponentType.TOGGLE_BUTTON, x: 7, y: 1, width: 1, height: 1, targetInputs: [25]).toJSON(),
    "toggle button5": getDefaultComponentSetting(ComponentType.TOGGLE_BUTTON, x: 8, y: 1, width: 1, height: 1, targetInputs: [26]).toJSON(),
    
    "hat switch1": getDefaultComponentSetting(ComponentType.HAT_SWITCH, x: 4, y: 2, width: 2, height: 2, targetInputs: [27, 28, 29, 30]).toJSON(),

    "slider5": getDefaultComponentSetting(ComponentType.SLIDER, x: 6, y: 3, width: 3, height: 1, targetInputs: [3], inserts: {
      ComponentSettingType.LABEL: "",
      ComponentSettingType.SLIDER_USE_VERTICAL_AXIS: "false",
      ComponentSettingType.SLIDER_USE_GRADUATION_LABEL: "false",
      ComponentSettingType.SLIDER_DETENT_POINTS: "[10.0, 20.0, 30.0, 40.0, 50.0, 60.0]"
    }).toJSON(),
    "slider4": getDefaultComponentSetting(ComponentType.SLIDER, x: 6, y: 2, width: 3, height: 1, targetInputs: [4], inserts: {
      ComponentSettingType.LABEL: "",
      ComponentSettingType.SLIDER_USE_VERTICAL_AXIS: "false",
      ComponentSettingType.SLIDER_USE_GRADUATION_LABEL: "false"
    }).toJSON(),
  },
});

PanelSetting getManyComponentPanel(ComponentType componentType, int width, int height) {
  return PanelSetting.fromJSON("panel", {
    "width": width,
    "height": height,
    "components": () {
      Map<String, dynamic> rs = Map<String, dynamic>();
      for (int x = 0; x < width; x++)
        for (int y = 0; y < height; y++)
          rs[x.toString() + y.toString()] = getDefaultComponentSetting(
              componentType,
              x: x,
              y: y,
              width: 1,
              height: 1,
          ).toJSON();
      return rs;
    }(),
  });
}

Widget buildDebugArea(BuildContext context) {
  PanelSetting panelSetting = testComponentsPanel;

  printWrapped(jsonEncode(panelSetting.toJSON()));

  Size blockSize = PanelUtility.getBlockSize(panelSetting, MediaQuery.of(context).size);
  return Container(
    child: Panel(
      blockWidth: blockSize.width,
      blockHeight: blockSize.height,
      panelController: PanelController(),
      panelSetting: panelSetting,
    ),
  );
}

void printWrapped(String text) {
  RegExp('.{1,800}').allMatches(text).forEach((match) => print(match.group(0)));
}