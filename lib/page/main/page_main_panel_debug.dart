import 'package:VirtualFlightThrottle/panel/component/component_default_settings.dart';
import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/panel.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';

var panelSettings = PanelSetting.fromJSON("panel", {
  "width": 10,
  "height": 10,
  "components": {
    "slider1": getDefaultComponentSetting(ComponentType.SLIDER, x: 0, y: 0, width: 1, height: 10).toJSON(),
    "slider2": getDefaultComponentSetting(ComponentType.SLIDER, x: 1, y: 0, width: 1, height: 10).toJSON(),
    "slider9": () {
      var result = getDefaultComponentSetting(ComponentType.SLIDER, x: 4, y: 5, width: 4, height: 1);
      result.settings["axis"].setValue("false");
      result.settings["display-name"].setValue("   ");
      return result.toJSON();
    } (),
  },
});

Widget buildDebugArea(BuildContext context) {
  Size screenSize = MediaQuery.of(context).size;
  return Container(
    child: Panel(
      blockWidth: screenSize.width / panelSettings.width,
      blockHeight: screenSize.height / panelSettings.height,
      panelController: PanelController(),
      panelSetting: panelSettings,
    ),
  );
}