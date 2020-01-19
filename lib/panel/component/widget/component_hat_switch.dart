import 'package:VirtualFlightThrottle/panel/component/widget/component.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComponentHatSwitch extends Component {
  ComponentHatSwitch(
      {Key key,
      @required componentSetting,
      @required blockWidth,
      @required blockHeight}
      ): super(key: key, componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight);

  @override
  Widget buildComponent(BuildContext context) {
    return this._buildHatSwitch(
      context: context,
    );
  }

  Widget _buildHatSwitch({
    @required BuildContext context,
  }) {
    PanelController panelController = Provider.of<PanelController>(context, listen: false);

    void setPressed({bool left = false, bool top = false, bool right = false, bool bottom = false}) {
      panelController.eventDigital(componentSetting.targetInputs[0], left);
      panelController.eventDigital(componentSetting.targetInputs[1], top);
      panelController.eventDigital(componentSetting.targetInputs[2], right);
      panelController.eventDigital(componentSetting.targetInputs[3], bottom);
    }

    return Container(
      width: 100,
      height: 100,
      child: JoystickView(
        size: 100,
        backgroundColor: Color.fromRGBO(97, 97, 97, 1),
        innerCircleColor: Color.fromRGBO(97, 97, 97, 1),
        showArrows: false,
        onDirectionChanged: (degrees, distance) {
          if (distance < 0.5) setPressed();
          else if (this._inRange(degrees, 337.5, 22.5)) setPressed(top: true);
          else if (this._inRange(degrees, 22.5, 67.5)) setPressed(top: true, right: true);
          else if (this._inRange(degrees, 67.5, 112.5)) setPressed(right: true);
          else if (this._inRange(degrees, 112.5, 157.5)) setPressed(right: true, bottom: true);
          else if (this._inRange(degrees, 157.5, 205.5)) setPressed(bottom: true);
          else if (this._inRange(degrees, 202.5, 247.5)) setPressed(bottom: true, left: true);
          else if (this._inRange(degrees, 247.5, 292.5)) setPressed(left: true);
          else if (this._inRange(degrees, 292.5, 337.5)) setPressed(left: true, top: true);
        },
      ),
    );
  }

  bool _inRange(double value, double min, double max) {
    if (min < value) if (value < max) return true;
    return false;
  }
}
