import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:flutter/material.dart';

enum ComponentType {
  SLIDER,
  BUTTON,
  SWITCH,
}

abstract class ComponentBuilder {
  double blockWidth;
  double blockHeight;

  ComponentBuilder(this.blockWidth, this.blockHeight);

  Widget buildComponentWidget(ComponentSetting componentSetting);
}