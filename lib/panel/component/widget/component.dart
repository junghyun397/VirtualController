import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:flutter/material.dart';

abstract class Component extends StatelessWidget {
  final ComponentSetting componentSetting;

  final double blockWidth;
  final double blockHeight;

  Component(
      {Key key,
      @required this.componentSetting,
      @required this.blockWidth,
      @required this.blockHeight})
      : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      child: this.buildComponent(context),
    );
  }

  Widget buildComponent(BuildContext context);

  Widget wrapByName(Widget widget, String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        widget,
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            name,
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}
