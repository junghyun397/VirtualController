import 'package:VirtualFlightThrottle/panel/component/component_default_settings.dart';
import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/panel.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';

var testComponentsPanel = PanelSetting.fromJSON("panel", {
  "width": 15,
  "height": 7,
  "components": {
    "slider1": getDefaultComponentSetting(ComponentType.SLIDER, x: 0, y: 0, width: 1, height: 3).toJSON(),
    "slider2": getDefaultComponentSetting(ComponentType.SLIDER, x: 1, y: 0, width: 1, height: 3).toJSON(),
    "slider9": () {
      var result = getDefaultComponentSetting(ComponentType.SLIDER, x: 4, y: 2, width: 4, height: 1, targetInputs: [0]);
      result.settings["axis"].setValue("false");
      result.settings["display-name"].setValue("");
      return result.toJSON();
    } (),
    "slider10": () {
      var result = getDefaultComponentSetting(ComponentType.SLIDER, x: 4, y: 1, width: 4, height: 1, targetInputs: [0]);
      result.settings["axis"].setValue("false");
      result.settings["display-name"].setValue("");
      return result.toJSON();
    } (),
    "slider11": () {
      var result = getDefaultComponentSetting(ComponentType.SLIDER, x: 4, y: 0, width: 4, height: 1);
      result.settings["axis"].setValue("false");
      result.settings["display-name"].setValue("");
      return result.toJSON();
    } (),
    "button": getDefaultComponentSetting(ComponentType.BUTTON, x: 3, y: 1, width: 1, height: 1, targetInputs: [10]).toJSON(),
    "button1": getDefaultComponentSetting(ComponentType.BUTTON, x: 3, y: 2, width: 1, height: 1, targetInputs: [10]).toJSON(),
    "button2": getDefaultComponentSetting(ComponentType.BUTTON, x: 3, y: 3, width: 1, height: 1, targetInputs: [10]).toJSON(),
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
              targetInputs: [0]).toJSON();
      return rs;
    }(),
  });
}

Widget buildDebugArea(BuildContext context) {
  var size = PanelUtility.getMaxPanelSize(MediaQuery.of(context).size);
  PanelSetting panelSetting = getManyComponentPanel(ComponentType.SLIDER, size.a, size.b);
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