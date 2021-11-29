import 'package:vfcs/app_manager.dart';
import 'package:vfcs/panel/component/component_definition.dart';
import 'package:vfcs/panel/component/component_data.dart';
import 'package:vfcs/panel/panel_controller.dart';
import 'package:vfcs/panel/panel_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Panel extends StatelessWidget {
  
  final PanelData panelData;

  final double blockSize;

  Panel({
    required Key key,
    required this.panelData,
    required this.blockSize,
  }) : super(key: key);

  List<Widget> _buildPanelComponents(BuildContext context) {
    final List<Widget> result = List.empty(growable: true);
    this.panelData.components.forEach((key, val) {
      result.add(Positioned(
        left: val.x * this.blockSize,
        bottom: val.y * this.blockSize,
        child: Center(
          child: Container(
            child: SizedBox(
              width: val.width * this.blockSize,
              height: val.height * this.blockSize,
              child: COMPONENT_DEFINITION[val.componentType]!.build(val, this.blockSize, this.blockSize),
            ),
          ),
        ),
      ));
    });
    return result;
  }

  List<Widget> _buildCouplingButtons(BuildContext context) {
    final List<Widget> result = List.empty(growable: true);
    this.panelData.components.forEach((key, component) {
      if (component.componentType == ComponentType.SLIDER) {
        for (ComponentData targetComponent in this.panelData.components.values) {
          if (component.x + component.width == targetComponent.x
              && component.y == targetComponent.y
              && component.height == targetComponent.height) {
            result.add(Selector<PanelController, bool>(
                selector: (context, value) => value.hasAnalogueSync(component.targetInputs[0]),
                builder: (context, enabled, widget) {
                  final PanelController panelController = Provider.of<PanelController>(context, listen: false);
                  return Positioned(
                    left: (component.x + component.width) * this.blockSize - 14,
                    bottom: component.y * this.blockSize + 4,
                    child: GestureDetector(
                      child: Center(
                        child: Icon(
                          Icons.link,
                          color: panelController.hasAnalogueSync(component.targetInputs[0]) ? Colors.green : Colors.grey,
                        ),
                      ),
                      onTap: () => panelController.switchAnalogueSync(component.targetInputs[0], targetComponent.targetInputs[0]),
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
    final AppManager appManager = AppManager.byContext(context);
    return ChangeNotifierProvider<PanelController>(
      create: (_) => PanelController(appManager.networkManager, appManager.settingManager),
      child: Stack(
        children: [
          ...this._buildPanelComponents(context),
          ...this._buildCouplingButtons(context),
        ],
      ),
    );
  }
}
