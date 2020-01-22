import 'dart:convert';

import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:flutter/cupertino.dart';

abstract class ComponentSettingData<T> {
  T value;
  Type type;

  ComponentSettingType settingType;

  ComponentSettingData(this.settingType, String sourceString) {
    this.setValue(sourceString);
    this.type = this.value.runtimeType;
  }

  void setValue(String sourceString);

  Map<String, dynamic> toJSON() {
    return {
      "type": this.type.toString(),
      "value": this.value.toString(),
    };
  }
}

class StringComponentSettingData extends ComponentSettingData<String> {
  StringComponentSettingData(ComponentSettingType settingType, String sourceString): super(settingType, sourceString);

  @override
  void setValue(String sourceString) => this.value = sourceString;
}

class BooleanComponentSettingData extends ComponentSettingData<bool> {
  BooleanComponentSettingData(ComponentSettingType settingType, String sourceString): super(settingType, sourceString);

  @override
  void setValue(String sourceString) => value = sourceString.toUpperCase() == "TRUE" ? true : false;
}

class IntegerComponentSettingData extends ComponentSettingData<int> {
  IntegerComponentSettingData(ComponentSettingType settingType, String sourceString): super(settingType, sourceString);

  @override
  void setValue(String sourceString) => value = int.parse(sourceString);
}

class DoubleComponentSettingData extends ComponentSettingData<double> {
  DoubleComponentSettingData(ComponentSettingType settingType, String sourceString): super(settingType, sourceString);

  @override
  void setValue(String sourceString) => value = double.parse(sourceString);
}

class DoubleListComponentSettingData extends ComponentSettingData<List<double>> {
  DoubleListComponentSettingData(ComponentSettingType settingType, String sourceString): super(settingType, sourceString);

  @override
  void setValue(String sourceString) => value = json.decode(sourceString).cast<double>();

  Map<String, dynamic> toJSON() {
    return {
      "type": "List<double>",
      "value": this.value.toString(),
    };
  }
}

class ComponentSetting {
  String name;

  ComponentType componentType;

  int x, y;
  int width, height;

  List<int> targetInputs;

  Map<ComponentSettingType, ComponentSettingData> settings = Map<ComponentSettingType, ComponentSettingData>();

  ComponentSetting({
    @required this.name,

    @required this.componentType,

    @required this.x,
    @required this.y,
    @required this.width,
    @required this.height,

    @required this.targetInputs,
  });

  ComponentSetting.fromJSON(this.name, Map<String, dynamic> json) {
    this.componentType = getEnumFromString(ComponentType.values, json["component_type"]);

    this.x = json["x"];
    this.y = json["y"];
    this.width = json["width"];
    this.height = json["height"];

    this.targetInputs = json["target_inputs"];

    json["settings"].forEach((key, val) {
      ComponentSettingType settingType = getEnumFromString(ComponentSettingType.values, key);
      this.settings[settingType] = () {
        switch (val["type"]) {
          case "String":
            return StringComponentSettingData(settingType, val["value"].toString());
            break;
          case "bool":
            return BooleanComponentSettingData(settingType, val["value"].toString());
            break;
          case "int":
            return IntegerComponentSettingData(settingType, val["value"].toString());
            break;
          case "double":
            return DoubleComponentSettingData(settingType, val["value"].toString());
            break;
          case "List<double>":
            return DoubleListComponentSettingData(settingType, val["value"].toString());
            break;
          default:
            return StringComponentSettingData(settingType, val["value"].toString());
            break;
        }
      } ();
    });
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> result = Map<String, dynamic>();

    result["component_type"] = this.componentType.toString();

    result["x"] = this.x;
    result["y"] = this.y;
    result["width"] = this.width;
    result["height"] = this.height;
    
    result["target_inputs"] = this.targetInputs;
    
    Map<String, dynamic> data = Map<String, dynamic>();
    this.settings.forEach((key, val) => data[key.toString()] = val.toJSON());
    result["settings"] = data;
    
    return result;
  }

  T getSettingsOr<T>(ComponentSettingType settingType, T defaultValue) {
    if (this.settings.containsKey(settingType)) return this.settings[settingType].value;
    else return defaultValue;
  }

}
