import 'dart:convert';

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

class ComponentSettingDefinition<T> {
  final String displaySettingName;
  final String description;

  String Function(BuildContext) getL10nComponentName;
  String Function(BuildContext) getL10nDescription;

  final ComponentSettingData<T> defaultValue;
  final String Function(dynamic) validator;

  ComponentSettingDefinition({
    @required this.displaySettingName,
    @required this.description,

    @required this.defaultValue,
    @required this.validator,
  });

}

// ignore: non_constant_identifier_names
final Map<ComponentSettingType, ComponentSettingDefinition> COMPONENT_SETTING_DEFINITION = {
  ComponentSettingType.LABEL: ComponentSettingDefinition<String>(
    defaultValue: StringComponentSettingData(ComponentSettingType.LABEL, "NAME"),
    displaySettingName: "Label",
    description: "Set component label",
    validator: (val) {
      if ((!new RegExp("^[A-Z0-9-._]{1,6}\$").hasMatch(val)) && val != "")
        return "Only uppercase up to 6 characters are allowed.";
      else return null;
    },
  ),

  ComponentSettingType.SLIDER_RANGE: ComponentSettingDefinition<double>(
    defaultValue: DoubleComponentSettingData(ComponentSettingType.SLIDER_RANGE, "100.0"),
    displaySettingName: "Range",
    description: "Set slider range",
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_INTEGER_RANGE: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_INTEGER_RANGE, "false"),
    displaySettingName: "Use Integer range",
    description: "Enable integer units on the slider",
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_UNIT_NAME: ComponentSettingDefinition<String>(
    defaultValue: StringComponentSettingData(ComponentSettingType.SLIDER_UNIT_NAME, "v"),
    displaySettingName: "Unit name",
    description: "Set slider unit name",
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_VERTICAL_AXIS: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_VERTICAL_AXIS, "true"),
    displaySettingName: "Use vertical axis",
    description: "Use vertical axis (use horizontal axis when disabled)",
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP, "true"),
    displaySettingName: "Use current value popup",
    description: "Enable display of current values popup",
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_HATCH_MARK_DENSITY: ComponentSettingDefinition<double>(
    defaultValue: DoubleComponentSettingData(ComponentSettingType.SLIDER_HATCH_MARK_DENSITY, "0.4"),
    displaySettingName: "Hatch mark density",
    description: "Set hatch mark density",
    validator: (val) {
      if (0 < val && val < 1) return null;
      else return "Only values between 0 and 1 are allowed.";
    },
  ),
  ComponentSettingType.SLIDER_HATCH_MARK_INDEX_COUNT: ComponentSettingDefinition<int>(
    defaultValue: IntegerComponentSettingData(ComponentSettingType.SLIDER_HATCH_MARK_INDEX_COUNT, "9"),
    displaySettingName: "Hatch mark index count",
    description: "Set hatch mark index count",
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_HATCH_MARK_LABEL: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_HATCH_MARK_LABEL, "true"),
    displaySettingName: "Use hatch mark lable",
    description: "Enable hatch mark label display",
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_DETENT_POINTS: ComponentSettingDefinition<List<double>>(
    defaultValue: DoubleListComponentSettingData(ComponentSettingType.SLIDER_DETENT_POINTS, "[]"),
    displaySettingName: "Detent points",
    description: "Set detent positions",
    validator: (val) {
      try {
        if (jsonDecode(val).cast<double>().runtimeType.toString() == "CastList<dynamic, double>") return null;
      } catch (e) {}
      return "Only the format [22.2, 42.0 ...] is allowed.";
    },
  ),
  
  ComponentSettingType.BUTTON_LABEL: ComponentSettingDefinition(
    defaultValue: StringComponentSettingData(ComponentSettingType.BUTTON_LABEL, "BTN"),
    displaySettingName: "Button lable",
    description: "Set button lable",
    validator: (val) {
      if ((!new RegExp("^[A-Z0-9-._]{1,4}\$").hasMatch(val)) && val != "")
        return "Only uppercase up to 4 characters are allowed.";
      else return null;
    },
  ),
};

// --- Component ---

enum ComponentOutputType {
  ANALOGUE,
  DIGITAL,
}

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
  final int needInputs;
  
  final ComponentOutputType outputType;

  Map<String, dynamic> defaultSettings = Map<String, dynamic>();

  final Component Function(ComponentSetting componentSetting, double blockWidth, double blockHeight) build;

  ComponentDefinition({
    @required this.displayComponentName,
    @required this.description,

    @required this.minWidth,
    @required this.minHeight,
    @required this.needInputs,
    
    @required this.outputType,
    
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
    needInputs: 1,
    
    outputType: ComponentOutputType.ANALOGUE,
    
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

    build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) =>
        ComponentSlider(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
  
  ComponentType.BUTTON: ComponentDefinition(
    displayComponentName: "Button",
    description: "Square button",

    minWidth: 1,
    minHeight: 1,
    needInputs: 1,

    outputType: ComponentOutputType.DIGITAL,

    defaultSettings: [
        ComponentSettingType.LABEL,

        ComponentSettingType.BUTTON_LABEL,
      ],

    build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) =>
        ComponentButton(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
  
  ComponentType.TOGGLE_BUTTON: ComponentDefinition(
    displayComponentName: "Toggle Button",
    description: "Square toggle button",
    
    minWidth: 1,
    minHeight: 1,
    needInputs: 1,
    
    outputType: ComponentOutputType.DIGITAL,
    
    defaultSettings: [
      ComponentSettingType.LABEL,
      
      ComponentSettingType.BUTTON_LABEL,
    ],

    build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) =>
        ComponentToggleButton(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
  
  ComponentType.TOGGLE_SWITCH: ComponentDefinition(
    displayComponentName: "Toggle Switch",
    description: "2-channel toggle switch",
    
    minWidth: 1,
    minHeight: 1,
    needInputs: 2,
    
    outputType: ComponentOutputType.DIGITAL,
    
    defaultSettings: [
      ComponentSettingType.LABEL,
    ],

    build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) =>
        ComponentToggleSwitch(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),

  ComponentType.HAT_SWITCH: ComponentDefinition(
    displayComponentName: "Hat Switch",
    description: "Simple hat switch",

    minWidth: 2,
    minHeight: 2,
    needInputs: 4,

    outputType: ComponentOutputType.DIGITAL,

    defaultSettings: [
      ComponentSettingType.LABEL,
    ],

    build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) =>
        ComponentHatSwitch(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
};

ComponentSetting getDefaultComponentSetting(
    ComponentType componentType, {
      @required String name,
      @required int x,
      @required int y,
      @required int width,
      @required int height,
      @required List<int> targetInputs,
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
    PanelSetting.fromJSON(name,
        {"width": width, "height": height, "components": {}, "date": DateTime.now().millisecondsSinceEpoch});