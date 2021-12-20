import 'package:vfcs/panel/component/component_data.dart';
import 'package:flutter/material.dart';

abstract class ComponentThemeData {

}

abstract class Component extends StatelessWidget {

  final ComponentData componentSetting;

  final int blockWidth;
  final int blockHeight;

  Component(
      {Key? key,
      required this.componentSetting,
      required this.blockWidth,
      required this.blockHeight})
      : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      child: Flexible(child: this.buildComponent(context)),
    );
  }

  Widget buildComponent(BuildContext context);

}
