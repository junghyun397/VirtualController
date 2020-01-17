import 'package:VirtualFlightThrottle/panel/component/widget/component.dart';
import 'package:flutter/material.dart';

class ComponentToggleButton extends Component {
  ComponentToggleButton(
      {Key key,
      @required componentSetting,
      @required blockWidth,
      @required blockHeight})
      : super(
            key: key,
            componentSetting: componentSetting,
            blockWidth: blockWidth,
            blockHeight: blockHeight);

  @override
  Widget buildComponent(BuildContext context) {
    return Container();
  }
}
