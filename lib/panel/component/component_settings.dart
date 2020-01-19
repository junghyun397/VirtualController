import 'dart:convert';

import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:flutter/cupertino.dart';

abstract class ComponentSettingData<T> {
  T value;
  Type type;

  String settingName;

  ComponentSettingData(this.settingName, String sourceString) {
    this.setValue(sourceString);
    this.type = this.value.runtimeType;
  }

  void setValue(String sourceString);

  copy();

  Map<String, dynamic> toJSON() {
    return {
      "type": this.type.toString(),
      "value": this.value.toString(),
    };
  }
}

class StringComponentSettingData extends ComponentSettingData<String> {
  StringComponentSettingData(String settingName, String sourceString): super(settingName, sourceString);

  StringComponentSettingData copy() => StringComponentSettingData(settingName, this.value.toString());

  @override
  void setValue(String sourceString) => this.value = sourceString;
}

class BooleanComponentSettingData extends ComponentSettingData<bool> {
  BooleanComponentSettingData(String settingName, String sourceString): super(settingName, sourceString);

  BooleanComponentSettingData copy() => BooleanComponentSettingData(settingName, this.value.toString());

  @override
  void setValue(String sourceString) => value = sourceString.toUpperCase() == "TRUE" ? true : false;
}

class IntegerComponentSettingData extends ComponentSettingData<int> {
  IntegerComponentSettingData(String settingName, String sourceString): super(settingName, sourceString);

  IntegerComponentSettingData copy() => IntegerComponentSettingData(settingName, this.value.toString());

  @override
  void setValue(String sourceString) => value = int.parse(sourceString);
}

class DoubleComponentSettingData extends ComponentSettingData<double> {
  DoubleComponentSettingData(String settingName, String sourceString): super(settingName, sourceString);

  DoubleComponentSettingData copy() => DoubleComponentSettingData(settingName, this.value.toString());

  @override
  void setValue(String sourceString) => value = double.parse(sourceString);
}

class DoubleListComponentSettingData extends ComponentSettingData<List<double>> {
  DoubleListComponentSettingData(String settingName, String sourceString): super(settingName, sourceString);

  DoubleListComponentSettingData copy() => DoubleListComponentSettingData(settingName, this.value.toString());

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

  Map<String, ComponentSettingData> settings = Map<String, ComponentSettingData>();

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
      this.settings[key] = () {
        switch (val["type"]) {
          case "String":
            return StringComponentSettingData(key, val["value"].toString());
            break;
          case "bool":
            return BooleanComponentSettingData(key, val["value"].toString());
            break;
          case "int":
            return IntegerComponentSettingData(key, val["value"].toString());
            break;
          case "double":
            return DoubleComponentSettingData(key, val["value"].toString());
            break;
          case "List<double>":
            return DoubleListComponentSettingData(key, val["value"].toString());
            break;
          default:
            return StringComponentSettingData(key, val["value"].toString());
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
    this.settings.forEach((key, val) => data[key] = val.toJSON());
    result["settings"] = data;
    
    return result;
  }

  T getSettingsOr<T>(String settingName, T defaultValue) {
    if (this.settings.containsKey(settingName))
      return this.settings[settingName].value;
    else return defaultValue;
  }

}
