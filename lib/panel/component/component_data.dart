import 'package:vfcs/panel/component/component_definition.dart';
import 'package:vfcs/panel/component/component_settings.dart';
import 'package:vfcs/panel/component/component_settings_definition.dart';
import 'package:vfcs/utility/utility_dart.dart';

class ComponentData {
  late String name;

  late ComponentType componentType;

  late int x, y;
  late int width, height;

  late List<int> targetInputs;

  final Map<ComponentSettingType, ComponentSettingData> settings;

  ComponentData({
    required this.name,

    required this.componentType,

    required this.x,
    required this.y,
    required this.width,
    required this.height,

    required this.targetInputs,

    required this.settings,
  });

  factory ComponentData.fromJSON(String name, Map<String, dynamic> json) =>
    ComponentData(
      name: name,
      componentType: getEnumFromString(ComponentType.values, json["component_type"]),
      x: json["x"],
      y: json["y"],
      width: json["width"],
      height: json["height"],
      targetInputs: json["target_inputs"].cast<int>(),
      settings: (json["settings"] as Map<String, dynamic>).map((key, value) {
        final ComponentSettingType settingType = getEnumFromString(ComponentSettingType.values, key);
        final ComponentSettingData componentSetting;
        switch (value["type"]) {
          case "String":
            componentSetting = StringComponentSettingData(settingType, value["value"].toString());
            break;
          case "bool":
            componentSetting = BooleanComponentSettingData(settingType, value["value"].toString());
            break;
          case "int":
            componentSetting = IntegerComponentSettingData(settingType, value["value"].toString());
            break;
          case "double":
            componentSetting = DoubleComponentSettingData(settingType, value["value"].toString());
            break;
          case "List<double>":
            componentSetting = DoubleListComponentSettingData(settingType, value["value"].toString());
            break;
          default:
            componentSetting = StringComponentSettingData(settingType, value["value"].toString());
            break;
        }
        return MapEntry(settingType, componentSetting);
      }),
    );

  Map<String, dynamic> toJSON() =>
    {
      "component_type": this.componentType.toString(),
      "x": this.x,
      "y": this.y,
      "width": this.width,
      "height": this.height,
      "target_inputs": this.targetInputs,
      "settings": this.settings.map((key, value) => MapEntry(key.toString(), value.toJSON())),
    };

  T getSettingsOr<T>(ComponentSettingType settingType, T defaultValue) {
    if (this.settings.containsKey(settingType)) return this.settings[settingType]!.value;
    else return defaultValue;
  }

}
