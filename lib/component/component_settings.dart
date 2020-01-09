import 'dart:convert';

abstract class ComponentDataSetting<T> {
  T value;
  Type type;
  
  String settingName;

  ComponentDataSetting(String sourceString, this.settingName) {
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
  StringComponentDataSetting(String sourceString, String settingName) : super(sourceString, settingName);

  @override
  void setValue(String sourceString) => this.value = sourceString;
}

class BooleanComponentDataSetting extends ComponentDataSetting<bool> {
  BooleanComponentDataSetting(String sourceString, String settingName) : super(sourceString, settingName);

  @override
  void setValue(String sourceString) => value = sourceString.toUpperCase() == "TRUE" ? true : false;
}

class IntegerComponentDataSetting extends ComponentDataSetting<int> {
  IntegerComponentDataSetting(String sourceString, String settingName) : super(sourceString, settingName);

  @override
  void setValue(String sourceString) => value = int.parse(sourceString);
}

class DoubleComponentDataSetting extends ComponentDataSetting<double> {
  DoubleComponentDataSetting(String sourceString, String settingName) : super(sourceString, settingName);

  @override
  void setValue(String sourceString) => value = double.parse(sourceString);
}

class DoubleListComponentDataSetting extends ComponentDataSetting<List<double>> {
  DoubleListComponentDataSetting(String sourceString, String settingName) : super(sourceString, settingName);

  @override
  void setValue(String sourceString) => value = json.decode(sourceString);
}

class ComponentSetting {
  String name;

  int width;
  int height;
  String controllerType;
  int targetInput;

  Map<String, ComponentDataSetting> settings = new Map<String, ComponentDataSetting>();

  ComponentSetting.fromJSON(this.name, Map<String, dynamic> json) {
    this.width = json["width"];
    this.height = json["height"];
    
    this.controllerType = json["controller_type"];
    this.targetInput = json["target_input"];

    json["settings"].forEach((key, val) {
      ComponentDataSetting componentSetting;
      switch (val["type"]) {
        case "String":
          componentSetting = StringComponentDataSetting(val["value"].toString(), key);
          break;
        case "bool":
          componentSetting = BooleanComponentDataSetting(val["value"].toString(), key);
          break;
        case "int":
          componentSetting = IntegerComponentDataSetting(val["value"].toString(), key);
          break;
        case "double":
          componentSetting = BooleanComponentDataSetting(val["value"].toString(), key);
          break;
        case "List<double>":
          componentSetting = DoubleListComponentDataSetting(val["value"].toString(), key);
          break;
        default:
          componentSetting = StringComponentDataSetting(val["value"].toString(), key);
          break;
      }

      this.settings[key] = componentSetting;
    });
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> result = new Map<String, dynamic>();

    result["width"] = this.width;
    result["height"] = this.height;
    
    result["controller_type"] = this.controllerType;
    result["target_input"] = this.targetInput;
    
    Map<String, String> data = new Map<String, String>();
    this.settings.forEach((key, val) => data[key] = val.toString());
    result["settings"] = data;
    
    return result;
  }

}
