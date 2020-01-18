import 'package:VirtualFlightThrottle/panel/component/widget/component_button.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
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

      buttonText: this.componentSetting.getSettingsOr("button-text", ""),
    );
  }

  Widget _buildButton({
    @required BuildContext context,

    @required String buttonText,
  }) {
    PanelController panelController = Provider.of<PanelController>(context, listen: false);
    return ComponentButtonWidget(
      buttonText: buttonText,
      toggleValue: true,
      onForward: () => panelController.eventDigital(this.componentSetting.targetInputs[0], true),
      onReverse: () => panelController.eventDigital(this.componentSetting.targetInputs[0], false),
    );
  }

}
