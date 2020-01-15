import 'dart:convert';

import 'package:VirtualFlightThrottle/utility/utility_dart.dart';

abstract class ComponentSettingData<T> {
  T value;
  Type type;

  String settingName;

  ComponentSettingData(this.settingName, String sourceString) {
    this.setValue(sourceString);
    this.type = this.value.runtimeType;
  }

  void setValue(String sourceString);
  
  @override
  String toString() {
    return '{type: "${this.type.toString()}", value: ${this.value.toString()}}';
  }
}

class StringComponentSettingData extends ComponentSettingData<String> {
  StringComponentSettingData(String settingName, String sourceString)
      : super(settingName, sourceString);

  @override
  void setValue(String sourceString) => this.value = sourceString;
}

class BooleanComponentSettingData extends ComponentSettingData<bool> {
  BooleanComponentSettingData(String settingName, String sourceString)
      : super(settingName, sourceString);

  @override
  void setValue(String sourceString) =>
      value = sourceString.toUpperCase() == "TRUE" ? true : false;
}

class IntegerComponentSettingData extends ComponentSettingData<int> {
  IntegerComponentSettingData(String settingName, String sourceString)
      : super(settingName, sourceString);

  @override
  void setValue(String sourceString) => value = int.parse(sourceString);
}

class DoubleComponentSettingData extends ComponentSettingData<double> {
  DoubleComponentSettingData(String settingName, String sourceString)
      : super(settingName, sourceString);

  @override
  void setValue(String sourceString) => value = double.parse(sourceString);
}

class DoubleListComponentSettingData
    extends ComponentSettingData<List<double>> {
  DoubleListComponentSettingData(String settingName, String sourceString)
      : super(settingName, sourceString);

  @override
  void setValue(String sourceString) => value = json.decode(sourceString);
}

enum ComponentType {
  SLIDER,
  BUTTON,
  SWITCH,
}

class ComponentSetting {
  String name;

  ComponentType componentType;

  int x, y;
  int width, height;

  List<int> targetInputs;

  Map<String, ComponentSettingData> settings = new Map<
      String,
      ComponentSettingData>();

  T getSettingsOr<T>(String settingName, T defaultValue) {
    if (this.settings.containsKey(settingName))
      return this.settings[settingName].value;
    else
      return defaultValue;
  }

  ComponentSetting.fromJSON(this.name, Map<String, dynamic> json) {
    this.componentType = UtilityDart.getEnumFromString(
        ComponentType.values, json["component_type"]);

    this.x = json["x"];
    this.y = json["y"];
    this.width = json["width"];
    this.height = json["height"];

    this.targetInputs = json["target_inputs"];

    json["settings"].forEach((key, val) {
      ComponentSettingData componentSetting;
      switch (val["type"]) {
        case "String":
          componentSetting =
              StringComponentSettingData(key, val["value"].toString());
          break;
        case "bool":
          componentSetting =
              BooleanComponentSettingData(key, val["value"].toString());
          break;
        case "int":
          componentSetting =
              IntegerComponentSettingData(key, val["value"].toString());
          break;
        case "double":
          componentSetting =
              BooleanComponentSettingData(key, val["value"].toString());
          break;
        case "List<double>":
          componentSetting =
              DoubleListComponentSettingData(key, val["value"].toString());
          break;
        default:
          componentSetting =
              StringComponentSettingData(key, val["value"].toString());
          break;
      }

      this.settings[key] = componentSetting;
    });
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> result = new Map<String, dynamic>();

    result["component_type"] = this.componentType.toString();

    result["x"] = this.x;
    result["y"] = this.y;
    result["width"] = this.width;
    result["height"] = this.height;
    
    result["target_inputs"] = this.targetInputs;
    
    Map<String, String> data = new Map<String, String>();
    this.settings.forEach((key, val) => data[key] = val.toString());
    result["settings"] = data;
    
    return result;
  }

}
