import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_button.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_slider.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_switch.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_toggle_button.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_toggle_switch_2axes.dart';
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

  List<Widget> _buildPanelComponents(BuildContext context) {
    List<Widget> result = List<Widget>();
    this.panelSetting.components.forEach((key, val) {
      result.add(Positioned(
        left: val.x * this.blockWidth,
        bottom: val.y * this.blockHeight,
        child: Center(
          child: Container(
//            color: Colors.red,
            child: SizedBox(
              width: val.width * this.blockWidth,
              height: val.height * this.blockHeight,
              child: () {
                switch (val.componentType) {
                  case ComponentType.SLIDER:
                    return ComponentSlider(
                      componentSetting: val,
                      blockWidth: blockWidth,
                      blockHeight: blockHeight,
                    );
                  case ComponentType.BUTTON:
                    return ComponentButton(
                      componentSetting: val,
                      blockWidth: blockWidth,
                      blockHeight: blockHeight,
                    );
                  case ComponentType.SWITCH:
                    return ComponentSwitch(
                      componentSetting: val,
                      blockWidth: blockWidth,
                      blockHeight: blockHeight,
                    );
                  case ComponentType.TOGGLE_BUTTON:
                    return ComponentToggleButton(
                      componentSetting: val,
                      blockWidth: blockWidth,
                      blockHeight: blockHeight,
                    );
                  case ComponentType.TOGGLE_SWITCH_2AXES:
                    return ComponentToggleSwitch2Axes(
                      componentSetting: val,
                      blockWidth: blockWidth,
                      blockHeight: blockHeight,
                    );
                  case ComponentType.TOGGLE_SWITCH_4AXES:
                    return ComponentToggleSwitch2Axes(
                      componentSetting: val,
                      blockWidth: blockWidth,
                      blockHeight: blockHeight,
                    );
                  default:
                    return Container();
                }
              } (),
            ),
          ),
        ),
      ));
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PanelController>(
      create: (_) => this.panelController,
      child: Stack(
        children: this._buildPanelComponents(context),
      ),
    );
  }
}
