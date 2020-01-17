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
    return Center(
      child: Column(
        children: <Widget>[
          Flexible(
            child: this.buildComponent(context),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              this.componentSetting.getSettingsOr("display-name", ""),
              style: TextStyle(color: Colors.white70),
            ),
          )
        ],
      ),
    );
  }

  Widget buildComponent(BuildContext context);

}
