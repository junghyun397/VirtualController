import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:vfcs/generated/l10n.dart';
import 'package:vfcs/panel/component/component_settings.dart';

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
  final String Function(BuildContext) getL10nName;
  final String Function(BuildContext) getL10nDescription;

  final ComponentSettingData<T> defaultValue;
  final String? Function(dynamic) validator;

  ComponentSettingDefinition({
    required this.getL10nName,
    required this.getL10nDescription,

    required this.defaultValue,
    required this.validator,
  });

}

ComponentSettingDefinition getComponentSettingDefinition(ComponentSettingType componentSettingType) =>
    COMPONENT_SETTING_DEFINITION[componentSettingType]!;

// ignore: non_constant_identifier_names
final Map<ComponentSettingType, ComponentSettingDefinition> COMPONENT_SETTING_DEFINITION = {
  ComponentSettingType.LABEL: ComponentSettingDefinition<String>(
    defaultValue: StringComponentSettingData(ComponentSettingType.LABEL, "NAME"),
    getL10nName: (context) => S.of(context).componentSettingInfo_label_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_label_description,
    validator: (val) {
      if (val.length > 15) return "Only up to 15 characters are allowed.";
      else return null;
    },
  ),

  ComponentSettingType.SLIDER_RANGE: ComponentSettingDefinition<double>(
    defaultValue: DoubleComponentSettingData(ComponentSettingType.SLIDER_RANGE, "100.0"),
    getL10nName: (context) => S.of(context).componentSettingInfo_sliderRange_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderRange_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_INTEGER_RANGE: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_INTEGER_RANGE, "false"),
    getL10nName: (context) => S.of(context).componentSettingInfo_sliderUseIntegerRange_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderUseIntegerRange_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_UNIT_NAME: ComponentSettingDefinition<String>(
    defaultValue: StringComponentSettingData(ComponentSettingType.SLIDER_UNIT_NAME, "v"),
    getL10nName: (context) => S.of(context).componentSettingInfo_sliderUnitName_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderUnitName_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_VERTICAL_AXIS: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_VERTICAL_AXIS, "true"),
    getL10nName: (context) => S.of(context).componentSettingInfo_sliderUseVerticalAxis_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderUseVerticalAxis_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP, "true"),
    getL10nName: (context) => S.of(context).componentSettingInfo_sliderUseCurrentValuePopup_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderUseCurrentValuePopup_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_TRACK_BAR_DENSITY: ComponentSettingDefinition<double>(
    defaultValue: DoubleComponentSettingData(ComponentSettingType.SLIDER_TRACK_BAR_DENSITY, "0.4"),
    getL10nName: (context) => S.of(context).componentSettingInfo_sliderTrackBarDensity_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderTrackBarDensity_description,
    validator: (val) {
      if (0 < val && val < 1) return null;
      else return "Only values between 0 and 1 are allowed.";
    },
  ),
  ComponentSettingType.SLIDER_TRACK_BAR_INDEX_COUNT: ComponentSettingDefinition<int>(
    defaultValue: IntegerComponentSettingData(ComponentSettingType.SLIDER_TRACK_BAR_INDEX_COUNT, "9"),
    getL10nName: (context) => S.of(context).componentSettingInfo_sliderTrackBarIndexCount_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderTrackBarIndexCount_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_USE_TRACK_BAR_LABEL: ComponentSettingDefinition<bool>(
    defaultValue: BooleanComponentSettingData(ComponentSettingType.SLIDER_USE_TRACK_BAR_LABEL, "true"),
    getL10nName: (context) => S.of(context).componentSettingInfo_sliderUseTrackBarLabel_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_sliderUseTrackBarLabel_description,
    validator: (val) => null,
  ),
  ComponentSettingType.SLIDER_DETENT_POINTS: ComponentSettingDefinition<List<double>>(
    defaultValue: DoubleListComponentSettingData(ComponentSettingType.SLIDER_DETENT_POINTS, "[]"),
    getL10nName: (context) => S.of(context).componentSettingInfo_sliderDetentPoints_name,
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
    getL10nName: (context) => S.of(context).componentSettingInfo_buttonLabel_name,
    getL10nDescription: (context) => S.of(context).componentSettingInfo_buttonLabel_description,
    validator: (val) {
      if (val.length > 15) return "Only up to 15 characters are allowed.";
      else return null;
    },
  ),
};
