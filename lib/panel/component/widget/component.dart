import 'package:vfcs/panel/component/component_definition.dart';
import 'package:vfcs/panel/component/component_data.dart';
import 'package:flutter/material.dart';

abstract class Component extends StatelessWidget {
  final ComponentData componentSetting;

  final double blockWidth;
  final double blockHeight;

  Component(
      {Key key,
      @required this.componentSetting,
      @required this.blockWidth,
      @required this.blockHeight})
      : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(child: this.buildComponent(context)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: this.blockWidth,
            height: 18,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                this.componentSetting.getSettingsOr(ComponentSettingType.LABEL, ""),
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildComponent(BuildContext context);

}
