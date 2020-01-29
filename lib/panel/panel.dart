import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Panel extends StatelessWidget {
  final PanelSetting panelSetting;

  final double blockWidth;
  final double blockHeight;

  Panel({
    Key key,
    @required this.blockWidth,
    @required this.blockHeight,
    @required this.panelSetting,
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

  List<Widget> _buildAnalogueSyncButtons(BuildContext context) {
    List<Widget> result = List<Widget>();
    this.panelSetting.components.forEach((key, component) {
      if (component.componentType == ComponentType.SLIDER) {
        for (ComponentSetting targetComponent in this.panelSetting.components.values) {
          if (component.x + 1 == targetComponent.x && component.y == targetComponent.y
              && component.width == targetComponent.width && component.height == targetComponent.height) {
            result.add(Selector<PanelController, bool>(
                selector: (context, value) => value.hasAnalogueSync(component.targetInputs[0]),
                builder: (context, bool enabled, Widget _) {
                  PanelController panelController = Provider.of<PanelController>(context, listen: false);
                  return Positioned(
                    left: (component.x + 1) * this.blockWidth - 14,
                    bottom: component.y * this.blockHeight + 4,
                    child: GestureDetector(
                      child: Center(
                        child: Icon(
                          Icons.link,
                          color: panelController.hasAnalogueSync(component.targetInputs[0]) ? Colors.green : Colors.grey,
                        ),
                      ),
                      onTap: () =>
                          panelController.switchAnalogueSync(component.targetInputs[0], targetComponent.targetInputs[0]),
                    ),
                  );
                }
            ));
            break;
          }
        }
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PanelController>(
      create: (_) => PanelController(),
      child: Stack(
        children: [
          ...this._buildPanelComponents(context),
          ...this._buildAnalogueSyncButtons(context),
        ],
      ),
    );
  }
}
