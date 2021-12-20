import 'package:vfcs/generated/l10n.dart';
import 'package:vfcs/panel/component/component_data.dart';
import 'package:vfcs/panel/component/component_settings_definition.dart';
import 'package:vfcs/panel/component/widgets/component.dart';
import 'package:vfcs/panel/component/widgets/component_button.dart';
import 'package:vfcs/panel/component/widgets/component_hat_switch.dart';
import 'package:vfcs/panel/component/widgets/component_slider.dart';
import 'package:vfcs/panel/component/widgets/component_toggle_button.dart';
import 'package:vfcs/panel/component/widgets/component_toggle_switch.dart';
import 'package:vfcs/panel/panel_data.dart';
import 'package:flutter/material.dart';

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
  final int requiredInputs;
  
  final ComponentOutputType outputType;

  final Map<String, dynamic> defaultSettings = Map<String, dynamic>();

  final Component Function(ComponentData componentSetting, double blockWidth, double blockHeight) build;

  ComponentDefinition({
    required this.getL10nComponentName,
    required this.getL10nDescription,
    required this.shortName,
    required this.labelName,

    required this.minWidth,
    required this.minHeight,
    required this.requiredInputs,
    
    required this.outputType,
    
    required List<ComponentSettingType> defaultSettings,

    required this.build,
  }) {
    defaultSettings.forEach((val) => this.defaultSettings[val.toString()] = COMPONENT_SETTING_DEFINITION[val]!.defaultValue.toJSON());
  }

}

ComponentDefinition getComponentDefinition(ComponentType componentType) =>
    COMPONENT_DEFINITION[componentType]!;

// ignore: non_constant_identifier_names
final Map<ComponentType, ComponentDefinition> COMPONENT_DEFINITION = {
  ComponentType.SLIDER: ComponentDefinition(
    getL10nComponentName: (context) => S.of(context).componentInfo_slider_name,
    getL10nDescription: (context) => S.of(context).componentInfo_slider_description,
    shortName: "Slider",
    labelName: "SLIDR",
    
    minWidth: 1,
    minHeight: 1,
    requiredInputs: 1,
    
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

    build: (ComponentData componentSetting, double blockWidth, double blockHeight) =>
        ComponentSlider(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
  
  ComponentType.BUTTON: ComponentDefinition(
    getL10nComponentName: (context) => S.of(context).componentInfo_button_name,
    getL10nDescription: (context) => S.of(context).componentInfo_button_description,
    shortName: "Button",
    labelName: "BTN",

    minWidth: 1,
    minHeight: 1,
    requiredInputs: 1,

    outputType: ComponentOutputType.DIGITAL,

    defaultSettings: [
        ComponentSettingType.LABEL,

        ComponentSettingType.BUTTON_LABEL,
      ],

    build: (ComponentData componentSetting, double blockWidth, double blockHeight) =>
        ComponentButton(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
  
  ComponentType.TOGGLE_BUTTON: ComponentDefinition(
    getL10nComponentName: (context) => S.of(context).componentInfo_toggleButton_name,
    getL10nDescription: (context) => S.of(context).componentInfo_toggleButton_description,
    shortName: "Toggle Button",
    labelName: "TBTN",

    minWidth: 1,
    minHeight: 1,
    requiredInputs: 1,
    
    outputType: ComponentOutputType.DIGITAL,
    
    defaultSettings: [
      ComponentSettingType.LABEL,
      
      ComponentSettingType.BUTTON_LABEL,
    ],

    build: (ComponentData componentSetting, double blockWidth, double blockHeight) =>
        ComponentToggleButton(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
  
  ComponentType.TOGGLE_SWITCH: ComponentDefinition(
    getL10nComponentName: (context) => S.of(context).componentInfo_toggleSwitch_name,
    getL10nDescription: (context) => S.of(context).componentInfo_toggleSwitch_description,
    shortName: "Toggle Switch",
    labelName: "SWICH",

    minWidth: 1,
    minHeight: 1,
    requiredInputs: 2,
    
    outputType: ComponentOutputType.DIGITAL,
    
    defaultSettings: [
      ComponentSettingType.LABEL,
    ],

    build: (ComponentData componentSetting, double blockWidth, double blockHeight) =>
        ComponentToggleSwitch(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),

  ComponentType.HAT_SWITCH: ComponentDefinition(
    getL10nComponentName: (context) => S.of(context).componentInfo_hatSwitch_name,
    getL10nDescription: (context) => S.of(context).componentInfo_hatSwitch_description,
    shortName: "Hat Switch",
    labelName: "HAT",

    minWidth: 2,
    minHeight: 2,
    requiredInputs: 4,

    outputType: ComponentOutputType.DIGITAL,

    defaultSettings: [
      ComponentSettingType.LABEL,
    ],

    build: (ComponentData componentSetting, double blockWidth, double blockHeight) =>
        ComponentHatSwitch(componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight),
  ),
};

ComponentData getDefaultComponentSetting(
    ComponentType componentType, {
      required String name,
      required int x,
      required int y,
      required int width,
      required int height,
      required List<int> targetInputs,
      Map<ComponentSettingType, String>? inserts,
    }) {
  ComponentData componentSetting = ComponentData.fromJSON(name, {
    "component_type": componentType.toString(),

    "x": x,
    "y": y,
    "width": width,
    "height": height,

    "target_inputs": targetInputs,

    "settings": COMPONENT_DEFINITION[componentType]!.defaultSettings,
  });

  if (inserts != null) inserts.forEach((key, val) => componentSetting.settings[key]!.setValue(val));
  return componentSetting;
}

// --- Panel ---

PanelData getBasicPanelSetting({required String name, required int width, required int height}) =>
    PanelData.fromJSON(name,
        {"width": width, "height": height, "components": {}, "date": DateTime.now().millisecondsSinceEpoch});