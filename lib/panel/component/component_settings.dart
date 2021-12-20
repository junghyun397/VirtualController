import 'dart:convert';

import 'package:vfcs/panel/component/component_definition.dart';
import 'package:vfcs/panel/component/component_settings_definition.dart';

abstract class ComponentSettingData<T> {

  late T value;
  late final Type type;

  final ComponentSettingType settingType;

  ComponentSettingData(this.settingType, String sourceString) {
    this.setValue(sourceString);
    this.type = this.value.runtimeType;
  }

  void setValue(String sourceString);

  Map<String, dynamic> toJSON() =>
      {
        "type": this.type.toString(),
        "value": this.value.toString(),
      };

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
