import 'package:collection/collection.dart';

import 'package:vfcs/app_manager.dart';
import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/panel/component/component_definition.dart';
import 'package:vfcs/panel/component/component_data.dart';
import 'package:vfcs/panel/panel_controller.dart';
import 'package:vfcs/panel/panel_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vfcs/panel/panel_theme.dart';
import 'package:vfcs/utility/utility_dart.dart';

class Panel extends StatelessWidget {

  final PanelController panelController;

  final PanelData panelData;

  final double blockSize;

  Panel({
    Key? key,
    required this.panelController,
    required this.panelData,
    required this.blockSize,
  }) : super(key: key);

  factory Panel.withAppManager({required AppManager appManager, required PanelData panelData, required double blockSize}) =>
      Panel(
        panelController: PanelController(panelData, appManager.networkManager, appManager.settingProvider),
        panelData: panelData,
        blockSize: blockSize,
      );

  Iterable<Widget> _buildComponents(BuildContext context) =>
      this.panelData.components.values.map((component) => Positioned(
        left: component.x * this.blockSize,
        bottom: component.y * this.blockSize,
        child: Center(
          child: Container(
            child: SizedBox(
              width: component.width * this.blockSize,
              height: component.height * this.blockSize,
              child: getComponentDefinition(component.componentType).build(component, this.blockSize, this.blockSize),
            ),
          ),
        ),
      ));

  Iterable<Widget> _buildCouplingButtons(BuildContext context) {
    final Iterable<ComponentData> sliders = this.panelData.components.values
        .where((component) => component.componentType == ComponentType.SLIDER);
    return sliders
        .map((slider) => Pair(slider, sliders
          .firstWhere((another) => slider.x + slider.width == another.x
            && slider.y == another.y
            && slider.height == another.height, orElse: null)))
        .whereNotNull()
        .map((coupled) => Selector<PanelController, bool>(
          selector: (context, value) => value.hasCoupling(coupled.a.targetInputs[0]),
          builder: (context, _, __) =>
            Positioned(
              left: (coupled.a.x + coupled.a.width) * this.blockSize - 14,
              bottom: coupled.a.y * this.blockSize + 4,
              child: GestureDetector(
                child: Center(
                  child: Icon(
                    Icons.link,
                    color: this.panelController.hasCoupling(coupled.a.targetInputs[0])
                        ? PanelTheme.of(context).couplingConnectedColor
                        : PanelTheme.of(context).couplingGreyColor,
                  ),
                ),
                onTap: () => this.panelController.switchAnalogueSync(coupled.a.targetInputs[0], coupled.b.targetInputs[0]),
              ),
            )));
  }

  Widget _buildBackgroundTitle(BuildContext context, AppManager appManager) {
    if (appManager.settingProvider.getSettingData(SettingType.USE_BACKGROUND_TITLE).value)
      return Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            this.panelController.panelData.name,
            style: TextStyle(
              fontSize: 1000,
              fontWeight: FontWeight.bold,
              color: PanelTheme.of(context).backgroundTitleColor,
            ),
          ),
        ),
      );
    else return Container();
  }

  @override
  Widget build(BuildContext context) {
    final AppManager appManager = AppManager.byContext(context);
    return ChangeNotifierProvider.value(
      value: this.panelController,
      child: PanelTheme(
        themeData: PanelThemeData.defaultData,
        child: Container(
          decoration: BoxDecoration(color: PanelTheme.of(context).backgroundColor),
          child: Stack(
            children: <Widget>[
              this._buildBackgroundTitle(context, appManager),
              ...this._buildComponents(context),
              ...this._buildCouplingButtons(context),
            ],
          ),
        ),
      ),
    );
  }
}
