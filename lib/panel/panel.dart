import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
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
            child: SizedBox(
              width: val.width * this.blockWidth,
              height: val.height * this.blockHeight,
              child: COMPONENT_DEFINITION[val.componentType].build(val, this.blockWidth, this.blockHeight),
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
