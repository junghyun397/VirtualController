import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_button.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_hat_switch.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_slider.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_toggle_button.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_toggle_switch.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';

// --- Component Settings ---

enum ComponentSettingType {
  LABEL,

  SLIDER_RANGE,
  SLIDER_USE_INTEGER_RANGE,
  SLIDER_UNIT_NAME,
  SLIDER_USE_VERTICAL_AXIS,
  SLIDER_USE_CURRENT_VALUE_POPUP,
  SLIDER_HATCH_MARK_DENSITY,
  SLIDER_HATCH_MARK_INDEX_COUNT,
  SLIDER_USE_HATCH_MARK_LABEL,
  SLIDER_DETENT_POINTS,

  BUTTON_LABEL,
}

class ComponentSettingDefinition {
  final String displaySettingName;
  final String description;

  String Function(BuildContext) getL10nComponentName;
  String Function(BuildContext) getL10nDescription;

  final ComponentSettingData defaultValue;
  final String regexp;

  ComponentSettingDefinition({
    @required this.displaySettingName,
    @required this.description,

    @required this.defaultValue,
    @required this.regexp,
  });

}

// ignore: non_constant_identifier_names
final Map<ComponentSettingType, ComponentSettingDefinition> COMPONENT_SETTING_DEFINITION = {
  ComponentSettingType.LABEL: ComponentSettingDefinition(
    defaultValue: StringComponentSettingData(ComponentSettingType.LABEL, "NAME"),
    displaySettingName: "Label",
    description: "Set component label",
    regexp: "",
  ),

  ComponentSettingType.SLIDER_RANGE: ComponentSettingDefinition(
    defaultValue: DoubleComponentSettingData(ComponentSettingType.SLIDER_RANGE, "100.0"),
    displaySettingName: "Range",
    description: "Set slider range",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_USE_INTEGER_RANGE: ComponentSettingDefinition(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_INTEGER_RANGE, "false"),
    displaySettingName: "Use Integer range",
    description: "Enable integer units on the slider",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_UNIT_NAME: ComponentSettingDefinition(
    defaultValue: StringComponentSettingData(ComponentSettingType.SLIDER_UNIT_NAME, "v"),
    displaySettingName: "Unit name",
    description: "Set slider unit name",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_USE_VERTICAL_AXIS: ComponentSettingDefinition(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_VERTICAL_AXIS, "true"),
    displaySettingName: "Use vertical axis",
    description: "Use vertical axis (use horizontal axis when disabled)",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP: ComponentSettingDefinition(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP, "true"),
    displaySettingName: "Use current value popup",
    description: "Enable display of current values popup",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_HATCH_MARK_DENSITY: ComponentSettingDefinition(
    defaultValue: DoubleComponentSettingData(ComponentSettingType.SLIDER_HATCH_MARK_DENSITY, "0.4"),
    displaySettingName: "Hatch mark density",
    description: "Set hatch mark density",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_HATCH_MARK_INDEX_COUNT: ComponentSettingDefinition(
    defaultValue: IntegerComponentSettingData(ComponentSettingType.SLIDER_HATCH_MARK_INDEX_COUNT, "9"),
    displaySettingName: "Hatch mark index count",
    description: "Set hatch mark index count",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_USE_HATCH_MARK_LABEL: ComponentSettingDefinition(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_HATCH_MARK_LABEL, "true"),
    displaySettingName: "Use hatch mark lable",
    description: "Enable hatch mark label display",
    regexp: "",
  ),
  ComponentSettingType.SLIDER_DETENT_POINTS: ComponentSettingDefinition(
    defaultValue: DoubleListComponentSettingData(ComponentSettingType.SLIDER_DETENT_POINTS, "[]"),
    displaySettingName: "Detent points",
    description: "Set detent positions",
    regexp: "",
  ),
  
  ComponentSettingType.BUTTON_LABEL: ComponentSettingDefinition(
    defaultValue: StringComponentSettingData(ComponentSettingType.BUTTON_LABEL, "BTN"),
    displaySettingName: "Button lable",
    description: "Set button lable",
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
  final String displayComponentName;
  final String description;

  String Function(BuildContext) getL10nComponentName;
  String Function(BuildContext) getL10nDescription;

  final int minWidth;
  final int minHeight;
  final int minTargetInputs;

  Map<String, dynamic> defaultSettings = Map<String, dynamic>();

  final Component Function(ComponentSetting componentSetting, double blockWidth, double blockHeight) build;

  ComponentDefinition({
    @required this.displayComponentName,
    @required this.description,

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
      displayComponentName: "Slider",
      description: "Configurable Throttle",

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
        ComponentSettingType.SLIDER_HATCH_MARK_DENSITY,
        ComponentSettingType.SLIDER_HATCH_MARK_INDEX_COUNT,
        ComponentSettingType.SLIDER_USE_HATCH_MARK_LABEL,
        ComponentSettingType.SLIDER_DETENT_POINTS,
      ],
      build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) => ComponentSlider(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
  
  ComponentType.BUTTON: ComponentDefinition(
      displayComponentName: "Button",
      description: "Square button",

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
      displayComponentName: "Toggle Button",
      description: "Square toggle button",

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
      displayComponentName: "Toggle Switch",
      description: "2-channel toggle switch",

      minWidth: 1,
      minHeight: 1,
      minTargetInputs: 2,
      defaultSettings: [
        ComponentSettingType.LABEL,
      ],
      build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) => ComponentToggleSwitch(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),

  ComponentType.HAT_SWITCH: ComponentDefinition(
      displayComponentName: "Hat Switch",
      description: "Simple hat switch",

      minWidth: 1,
      minHeight: 1,
      minTargetInputs: 4,
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

// --- Panel ---

PanelSetting getBasicPanelSetting({@required String name, @required int width, @required int height}) =>
    PanelSetting.fromJSON(name, {"width": width, "height": height, "components": {}, "date": DateTime.now().millisecondsSinceEpoch});