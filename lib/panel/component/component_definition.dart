import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_button.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_hat_switch.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_slider.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_toggle_button.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_toggle_switch.dart';
import 'package:flutter/material.dart';

// --- Component Settings ---

enum ComponentSettingType {
  LABEL,

  SLIDER_RANGE,
  SLIDER_USE_INTEGER_RANGE,
  SLIDER_UNIT_NAME,
  SLIDER_USE_VERTICAL_AXIS,
  SLIDER_USE_CURRENT_VALUE_POPUP,
  SLIDER_GRADUATED_DENSITY,
  SLIDER_GRADUATED_INDEX_DENSITY,
  SLIDER_USE_GRADUATION_LABEL,
  SLIDER_DETENT_POINTS,

  BUTTON_LABEL,
}

class ComponentSettingDefinition {
  final ComponentSettingData defaultValue;
  
  final String displaySettingName;
  final String regexp;

  ComponentSettingDefinition({this.defaultValue, this.displaySettingName, this.regexp});

  String getL10nDescription(BuildContext context) => "";
}

// ignore: non_constant_identifier_names
final Map<ComponentSettingType, ComponentSettingDefinition> COMPONENT_SETTING_DEFINITION = {
  ComponentSettingType.LABEL: ComponentSettingDefinition(
    defaultValue: StringComponentSettingData(ComponentSettingType.LABEL, "NAME"),
    displaySettingName: "Name tag",
    regexp: "",
  ),

  ComponentSettingType.SLIDER_RANGE: ComponentSettingDefinition(
    defaultValue: DoubleComponentSettingData(ComponentSettingType.SLIDER_RANGE, "100.0"),
    displaySettingName: "Range",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_USE_INTEGER_RANGE: ComponentSettingDefinition(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_INTEGER_RANGE, "false"),
    displaySettingName: "Display name",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_UNIT_NAME: ComponentSettingDefinition(
    defaultValue: StringComponentSettingData(ComponentSettingType.SLIDER_UNIT_NAME, "v"),
    displaySettingName: "Display name",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_USE_VERTICAL_AXIS: ComponentSettingDefinition(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_VERTICAL_AXIS, "true"),
    displaySettingName: "Display name",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP: ComponentSettingDefinition(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP, "true"),
    displaySettingName: "Display name",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_GRADUATED_DENSITY: ComponentSettingDefinition(
    defaultValue: DoubleComponentSettingData(ComponentSettingType.SLIDER_GRADUATED_DENSITY, "0.4"),
    displaySettingName: "Display name",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_GRADUATED_INDEX_DENSITY: ComponentSettingDefinition(
    defaultValue: IntegerComponentSettingData(ComponentSettingType.SLIDER_GRADUATED_INDEX_DENSITY, "9"),

    displaySettingName: "Display name",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_USE_GRADUATION_LABEL: ComponentSettingDefinition(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_GRADUATION_LABEL, "true"),
    displaySettingName: "Display name",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_DETENT_POINTS: ComponentSettingDefinition(
    defaultValue: DoubleListComponentSettingData(ComponentSettingType.SLIDER_DETENT_POINTS, "[]"),
    displaySettingName: "Display name",
    regexp: "",
  ),
  
  ComponentSettingType.BUTTON_LABEL: ComponentSettingDefinition(
    defaultValue: StringComponentSettingData(ComponentSettingType.BUTTON_LABEL, "BTN"),
    displaySettingName: "Display name",
    regexp: "",
  ),
};

// --- Component ---

enum ComponentType {
  SLIDER,
  BUTTON,
  TOGGLE_BUTTON,
  TOGGLE_SWITCH,
  HAT_SWITCH,
}

class ComponentDefinition {
  final int minWidth;
  final int minHeight;
  final int minTargetInputs;

  Map<String, dynamic> defaultSettings = Map<String, dynamic>();

  final Component Function(ComponentSetting componentSetting, double blockWidth, double blockHeight) build;

  ComponentDefinition({
    @required this.minWidth,
    @required this.minHeight,
    @required this.minTargetInputs,
    @required List<ComponentSettingType> defaultSettings,

    @required this.build,
  }) {
    defaultSettings.forEach((val) => this.defaultSettings[val.toString()] = COMPONENT_SETTING_DEFINITION[val].defaultValue.toJSON());
  }
}

// ignore: non_constant_identifier_names
final Map<ComponentType, ComponentDefinition> COMPONENT_DEFINITION = {
  ComponentType.SLIDER: ComponentDefinition(
      minWidth: 1,
      minHeight: 1,
      minTargetInputs: 1,
      defaultSettings: [
        ComponentSettingType.LABEL,

        ComponentSettingType.SLIDER_RANGE,
        ComponentSettingType.SLIDER_USE_INTEGER_RANGE,
        ComponentSettingType.SLIDER_UNIT_NAME,
        ComponentSettingType.SLIDER_USE_VERTICAL_AXIS,
        ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP,
        ComponentSettingType.SLIDER_GRADUATED_DENSITY,
        ComponentSettingType.SLIDER_GRADUATED_INDEX_DENSITY,
        ComponentSettingType.SLIDER_USE_GRADUATION_LABEL,
        ComponentSettingType.SLIDER_DETENT_POINTS,
      ],
      build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) => ComponentSlider(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
  
  ComponentType.BUTTON: ComponentDefinition(
      minWidth: 1,
      minHeight: 1,
      minTargetInputs: 1,
      defaultSettings: [
        ComponentSettingType.LABEL,

        ComponentSettingType.BUTTON_LABEL,
      ],
      build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) => ComponentButton(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
  
  ComponentType.TOGGLE_BUTTON: ComponentDefinition(
      minWidth: 1,
      minHeight: 1,
      minTargetInputs: 1,
      defaultSettings: [
        ComponentSettingType.LABEL,

        ComponentSettingType.BUTTON_LABEL,
      ],
      build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) => ComponentToggleButton(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
  
  ComponentType.TOGGLE_SWITCH: ComponentDefinition(
      minWidth: 1,
      minHeight: 1,
      minTargetInputs: 1,
      defaultSettings: [
        ComponentSettingType.LABEL,
      ],
      build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) => ComponentToggleSwitch(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),

  ComponentType.HAT_SWITCH: ComponentDefinition(
      minWidth: 1,
      minHeight: 1,
      minTargetInputs: 1,
      defaultSettings: [
        ComponentSettingType.LABEL,
      ],
      build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) => ComponentHatSwitch(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
};

ComponentSetting getDefaultComponentSetting(
    ComponentType componentType, {
      String name = "Unnamed conponent",
      @required int x,
      @required int y,
      @required int width,
      @required int height,
      List<int> targetInputs = const [-1, -1, -1, -1],
      Map<ComponentSettingType, String> inserts,
    }) {
  ComponentSetting componentSetting = ComponentSetting.fromJSON(name, {
    "component_type": componentType.toString(),

    "x": x,
    "y": y,
    "width": width,
    "height": height,

    "target_inputs": targetInputs,

    "settings": COMPONENT_DEFINITION[componentType].defaultSettings,
  });

  if (inserts != null) inserts.forEach((key, val) => componentSetting.settings[key].setValue(val));
  return componentSetting;
}
