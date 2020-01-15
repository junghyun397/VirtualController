import 'package:VirtualFlightThrottle/panel/component/widget/component.dart';
import 'package:flutter/material.dart';

class ComponentButton extends Component {
  ComponentButton(
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
  Widget build(BuildContext context) {
    return Container();
  }
}
