import 'package:VirtualFlightThrottle/panel/component/builder/component_builder.dart';
import 'package:VirtualFlightThrottle/panel/component/builder/component_builder_button.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';

class PanelBuilder {
  double panelWidth;
  double panelHeight;

  double blockWidth;
  double blockHeight;

  int minPossibleBlockWidth;
  int minPossibleBlockHeight;

  int maxPossibleBlockWidth;
  int maxPossibleBlockHeight;

  PanelBuilder(this.panelWidth, this.panelHeight);

  Widget buildPanelWidget(BuildContext context, PanelSetting panelSetting) {
    panelSetting.components.forEach((key, val) {
      switch (val.componentType) {
        case ComponentType.BUTTON:
          ComponentBuilderButton(this.blockWidth, this.blockHeight).buildComponentWidget(val);
          break;
        case ComponentType.SLIDER:
          break;
        case ComponentType.SWITCH:
          break;
      }
    });
    return Container();
  }

}