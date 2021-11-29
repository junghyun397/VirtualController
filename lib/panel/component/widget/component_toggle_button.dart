import 'package:vfcs/panel/component/component_definition.dart';
import 'package:vfcs/panel/component/widget/component_button.dart';
import 'package:vfcs/panel/panel_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComponentToggleButton extends ComponentButton {
  ComponentToggleButton(
      {Key key,
        @required componentSetting,
        @required blockWidth,
        @required blockHeight}
      ): super(key: key, componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight);

  @override
  Widget buildComponent(BuildContext context) {
    return this._buildButton(
      context: context,

      buttonLabel: this.componentSetting.getSettingsOr(ComponentSettingType.BUTTON_LABEL, ""),
    );
  }

  Widget _buildButton({
    @required BuildContext context,

    @required String buttonLabel,
  }) {
    PanelController panelController = Provider.of<PanelController>(context, listen: false);
    return ComponentButtonWidget(
      width: this.componentSetting.width * 50.0,
      height: this.componentSetting.height * 50.0,
      buttonLabel: buttonLabel,
      toggleValue: true,
      onForward: () => panelController.eventDigital(this.componentSetting.targetInputs[0], true),
      onReverse: () => panelController.eventDigital(this.componentSetting.targetInputs[0], false),
    );
  }

}
