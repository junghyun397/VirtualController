import 'dart:convert';

import 'package:VirtualFlightThrottle/panel/component/builder/component_builder.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';

abstract class ComponentDataSetting<T> {
  T value;
  Type type;
  
  String settingName;

  ComponentDataSetting(this.settingName, String sourceString) {
    this.setValue(sourceString);
    this.type = this.value.runtimeType;
  }
  
  void setValue(String sourceString);
  
  @override
  String toString() {
    return '{type: "${this.type.toString()}", value: ${this.value.toString()}}';
  }
}

class StringComponentDataSetting extends ComponentDataSetting<String> {
  StringComponentDataSetting(String settingName, String sourceString) : super(settingName, sourceString);

  @override
  void setValue(String sourceString) => this.value = sourceString;
}

class BooleanComponentDataSetting extends ComponentDataSetting<bool> {
  BooleanComponentDataSetting(String settingName, String sourceString) : super(settingName, sourceString);

  @override
  void setValue(String sourceString) => value = sourceString.toUpperCase() == "TRUE" ? true : false;
}

class IntegerComponentDataSetting extends ComponentDataSetting<int> {
  IntegerComponentDataSetting(String settingName, String sourceString) : super(settingName, sourceString);

  @override
  void setValue(String sourceString) => value = int.parse(sourceString);
}

class DoubleComponentDataSetting extends ComponentDataSetting<double> {
  DoubleComponentDataSetting(String settingName, String sourceString) : super(settingName, sourceString);

  @override
  void setValue(String sourceString) => value = double.parse(sourceString);
}

class DoubleListComponentDataSetting extends ComponentDataSetting<List<double>> {
  DoubleListComponentDataSetting(String settingName, String sourceString) : super(settingName, sourceString);

  @override
  void setValue(String sourceString) => value = json.decode(sourceString);
}

class ComponentSetting {
  String name;

  ComponentType componentType;

  int x, y;
  int width, height;

  List<int> targetInputs;

  Map<String, ComponentDataSetting> settings = new Map<String, ComponentDataSetting>();

  ComponentSetting.fromJSON(this.name, Map<String, dynamic> json) {
    this.componentType = UtilityDart.getEnumFromString(ComponentType.values, json["component_type"]);

    this.x = json["x"];
    this.y = json["y"];
    this.width = json["width"];
    this.height = json["height"];

    this.targetInputs = json["target_inputs"];

    json["settings"].forEach((key, val) {
      ComponentDataSetting componentSetting;
      switch (val["type"]) {
        case "String":
          componentSetting = StringComponentDataSetting(key, val["value"].toString());
          break;
        case "bool":
          componentSetting = BooleanComponentDataSetting(key, val["value"].toString());
          break;
        case "int":
          componentSetting = IntegerComponentDataSetting(key, val["value"].toString());
          break;
        case "double":
          componentSetting = BooleanComponentDataSetting(key, val["value"].toString());
          break;
        case "List<double>":
          componentSetting = DoubleListComponentDataSetting(key, val["value"].toString());
          break;
        default:
          componentSetting = StringComponentDataSetting(key, val["value"].toString());
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
