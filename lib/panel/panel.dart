import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_button.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_slider.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Panel extends StatelessWidget {
  final PanelSetting panelSetting;
  final PanelController panelController;

  final double blockWidth;
  final double blockHeight;

  Panel({
    Key key,
    @required this.blockWidth,
    @required this.blockHeight,
    @required this.panelSetting,
    @required this.panelController,
  }) : super(key: key);

  List<Widget> _buildPanelPositionedComponents(BuildContext context) {
    List<Widget> result = List<Widget>();
    this.panelSetting.components.forEach((key, val) {
      Widget componentWidget;
      switch (val.componentType) {
        case ComponentType.SLIDER:
          componentWidget = ComponentSlider(
            componentSetting: val,
            blockWidth: blockWidth,
            blockHeight: blockHeight,
          );
          break;
        case ComponentType.BUTTON:
          componentWidget = ComponentButton(
            componentSetting: val,
            blockWidth: blockWidth,
            blockHeight: blockHeight,
          );
          break;
        case ComponentType.SWITCH:
          componentWidget = ComponentSlider(
            componentSetting: val,
            blockWidth: blockWidth,
            blockHeight: blockHeight,
          );
          break;
        case ComponentType.TOGGLE_BUTTON:
          componentWidget = ComponentSlider(
            componentSetting: val,
            blockWidth: blockWidth,
            blockHeight: blockHeight,
          );
          break;
        case ComponentType.TOGGLE_SWITCH_2AXES:
          componentWidget = ComponentSlider(
            componentSetting: val,
            blockWidth: blockWidth,
            blockHeight: blockHeight,
          );
          break;
        case ComponentType.TOGGLE_SWITCH_4AXES:
          componentWidget = ComponentSlider(
            componentSetting: val,
            blockWidth: blockWidth,
            blockHeight: blockHeight,
          );
          break;
      }
      result.add(Positioned(
        left: val.x * this.blockWidth,
        width: this.blockWidth,
        top: val.y * this.blockHeight,
        height: this.blockHeight,
        child: componentWidget,
      ));
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Provider<PanelController>(
      create: (_) => this.panelController,
      child: Container(
        child: Stack(
          children: this._buildPanelPositionedComponents(context),
        ),
      ),
    );
  }
}
