import 'dart:convert';

import 'package:VirtualFlightThrottle/generated/l10n.dart';
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
  SLIDER_TRACK_BAR_DENSITY,
  SLIDER_TRACK_BAR_INDEX_COUNT,
  SLIDER_USE_TRACK_BAR_LABEL,
  SLIDER_DETENT_POINTS,

  BUTTON_LABEL,
}

class ComponentSettingDefinition<T> {
  final String Function(BuildContext) getL10nComponentName;
  final String Function(BuildContext) getL10nDescription;

  final ComponentSettingData<T> defaultValue;
  final String Function(dynamic) validator;

  ComponentSettingDefinition({
    @required this.getL10nComponentName,
    @required this.getL10nDescription,

    @required this.defaultValue,
    @required this.validator,
  });

}

// ignore: non_constant_identifier_names
final Map<ComponentSettingType, ComponentSettingDefinition> COMPONENT_SETTING_DEFINITION = {
  ComponentSettingType.LABEL: ComponentSettingDefinition<String>(
    defaultValue: StringComponentSettingData(ComponentSettingType.LABEL, "NAME"),
    getL10nComponentName: (context) => S.of(context).componentSettingInfo_label_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_label_description,
    validator: (val) {
      if ((!new RegExp("^[A-Z0-9-._]{1,6}\$").hasMatch(val)) && val != "")
        return "Only uppercase up to 6 characters are allowed.";
      else return null;
    },
  ),

  ComponentSettingType.SLIDER_RANGE: ComponentSettingDefinition<double>(
    defaultValue: DoubleComponentSettingData(ComponentSettingType.SLIDER_RANGE, "100.0"),
    getL10nComponentName: (context) => S.of(context).componentSettingInfo_sliderRange_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderRange_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_INTEGER_RANGE: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_INTEGER_RANGE, "false"),
    getL10nComponentName: (context) => S.of(context).componentSettingInfo_sliderUseIntegerRange_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderUseIntegerRange_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_UNIT_NAME: ComponentSettingDefinition<String>(
    defaultValue: StringComponentSettingData(ComponentSettingType.SLIDER_UNIT_NAME, "v"),
    getL10nComponentName: (context) => S.of(context).componentSettingInfo_sliderUnitName_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderUnitName_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_VERTICAL_AXIS: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_VERTICAL_AXIS, "true"),
    getL10nComponentName: (context) => S.of(context).componentSettingInfo_sliderUseVerticalAxis_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderUseVerticalAxis_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP, "true"),
    getL10nComponentName: (context) => S.of(context).componentSettingInfo_sliderUseCurrentValuePopup_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderUseCurrentValuePopup_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_TRACK_BAR_DENSITY: ComponentSettingDefinition<double>(
    defaultValue: DoubleComponentSettingData(ComponentSettingType.SLIDER_TRACK_BAR_DENSITY, "0.4"),
    getL10nComponentName: (context) => S.of(context).componentSettingInfo_sliderTrackBarDensity_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderTrackBarDensity_description,
    validator: (val) {
      if (0 < val && val < 1) return null;
      else return "Only values between 0 and 1 are allowed.";
    },
  ),
  ComponentSettingType.SLIDER_TRACK_BAR_INDEX_COUNT: ComponentSettingDefinition<int>(
    defaultValue: IntegerComponentSettingData(ComponentSettingType.SLIDER_TRACK_BAR_INDEX_COUNT, "9"),
    getL10nComponentName: (context) => S.of(context).componentSettingInfo_sliderTrackBarIndexCount_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderTrackBarIndexCount_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_TRACK_BAR_LABEL: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_TRACK_BAR_LABEL, "true"),
    getL10nComponentName: (context) => S.of(context).componentSettingInfo_sliderUseTrackBarLabel_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderUseTrackBarLabel_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_DETENT_POINTS: ComponentSettingDefinition<List<double>>(
    defaultValue: DoubleListComponentSettingData(ComponentSettingType.SLIDER_DETENT_POINTS, "[]"),
    getL10nComponentName: (context) => S.of(context).componentSettingInfo_sliderDetentPoints_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderDetentPoints_description,
    validator: (val) {
      try {
        if (jsonDecode(val).cast<double>().runtimeType.toString() == "CastList<dynamic, double>") return null;
      } catch (e) {}
      return "Only the format [22.2, 42.0 ...] is allowed.";
    },
  ),
  
  ComponentSettingType.BUTTON_LABEL: ComponentSettingDefinition(
    defaultValue: StringComponentSettingData(ComponentSettingType.BUTTON_LABEL, "BTN"),
    getL10nComponentName: (context) => S.of(context).componentSettingInfo_buttonLabel_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_buttonLabel_description,
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
  final String Function(BuildContext) getL10nComponentName;
  final String Function(BuildContext) getL10nDescription;
  final String shortName;
  final String labelName;

  final int minWidth;
  final int minHeight;
  final int needInputs;
  
  final ComponentOutputType outputType;

  Map<String, dynamic> defaultSettings = Map<String, dynamic>();

  final Component Function(ComponentSetting componentSetting, double blockWidth, double blockHeight) build;

  ComponentDefinition({
    @required this.getL10nComponentName,
    @required this.getL10nDescription,
    @required this.shortName,
    @required this.labelName,

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
    getL10nComponentName: (context) => S.of(context).componentInfo_slider_name,
    getL10nDescription: (context) => S.of(context).componentInfo_slider_description,
    shortName: "Slider",
    labelName: "SLIDR",
    
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
      ComponentSettingType.SLIDER_TRACK_BAR_DENSITY,
      ComponentSettingType.SLIDER_TRACK_BAR_INDEX_COUNT,
      ComponentSettingType.SLIDER_USE_TRACK_BAR_LABEL,
      ComponentSettingType.SLIDER_DETENT_POINTS,
    ],

    build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) =>
        ComponentSlider(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
  
  ComponentType.BUTTON: ComponentDefinition(
    getL10nComponentName: (context) => S.of(context).componentInfo_button_name,
    getL10nDescription: (context) => S.of(context).componentInfo_button_description,
    shortName: "Button",
    labelName: "BTN",

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
    getL10nComponentName: (context) => S.of(context).componentInfo_toggleButton_name,
    getL10nDescription: (context) => S.of(context).componentInfo_toggleButton_description,
    shortName: "Toggle Button",
    labelName: "TBTN",

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
    getL10nComponentName: (context) => S.of(context).componentInfo_toggleSwitch_name,
    getL10nDescription: (context) => S.of(context).componentInfo_toggleSwitch_description,
    shortName: "Toggle Switch",
    labelName: "SWICH",

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
    getL10nComponentName: (context) => S.of(context).componentInfo_hatSwitch_name,
    getL10nDescription: (context) => S.of(context).componentInfo_hatSwitch_description,
    shortName: "Hat Switch",
    labelName: "HAT",

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