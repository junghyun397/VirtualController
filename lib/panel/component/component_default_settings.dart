import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';

class ComponentDefaultSettings {
  static final ComponentDefaultSettings _singleton = ComponentDefaultSettings();

  factory ComponentDefaultSettings() => _singleton;

  ComponentDefaultSettings.internal();

  final Map<ComponentType, ComponentSetting> defaultSettingsMap = {
    ComponentType.SLIDER: ComponentSetting.fromJSON("Slider", {
      "component_type": ComponentType.SLIDER.toString(),
      "x": 0,
      "y": 0,
      "width": 1,
      "height": 0,
      "target_inputs": [0],
      "settings": {
        "display-name": {
          "type": "String",
          "value": "SLIDR",
        },
        "range": {
          "type": "int",
          "value": "100",
        },
        "use-int-range": {
          "type": "bool",
          "value": "false",
        },
        "unit-name": {
          "type": "String",
          "value": "SLIDR",
        },
        "axis": {
          "type": "bool",
          "value": "true",
        },
        "use-value-popup": {
          "type": "bool",
          "value": "true",
        },
        "mark-density": {
          "type": "double",
          "value": "0.4",
        },
        "mark-sight-count": {
          "type": "int",
          "value": "9",
        },
        "use-mark-sight-value": {
          "type": "bool",
          "value": "true",
        },
        "detent-points": {
          "type": "List<double>",
          "value": "[10, 20, 30]",
        },
      },
    }),
    ComponentType.BUTTON: ComponentSetting.fromJSON("Button", {
      "component_type": ComponentType.BUTTON.toString(),
      "x": 0,
      "y": 0,
      "width": 1,
      "height": 1,
      "target_inputs": [10],
      "settings": {
        "display-name": {
          "type": "String",
          "value": "SLIDR",
        },
      },
    }),
    ComponentType.SWITCH: ComponentSetting.fromJSON("Switch", {
      "component_type": ComponentType.SWITCH.toString(),
      "x": 0,
      "y": 0,
      "width": 1,
      "height": 1,
      "target_inputs": [11, 12],
      "settings": {
        "display-name": {
          "type": "String",
          "value": "SLIDR",
        },
      },
    }),
    ComponentType.TOGGLE_BUTTON: ComponentSetting.fromJSON("Toggle button", {
      "component_type": ComponentType.TOGGLE_BUTTON.toString(),
      "x": 0,
      "y": 0,
      "width": 1,
      "height": 1,
      "target_inputs": [13, 14],
      "settings": {
        "display-name": {
          "type": "String",
          "value": "SLIDR",
        },
      },
    }),
    ComponentType.TOGGLE_SWITCH_2AXES:
        ComponentSetting.fromJSON("Toggle 2-axes Switch", {
      "component_type": ComponentType.TOGGLE_SWITCH_2AXES.toString(),
      "x": 0,
      "y": 0,
      "width": 1,
      "height": 1,
      "target_inputs": [15, 16],
      "settings": {
        "display-name": {
          "type": "String",
          "value": "SLIDR",
        },
        "use-neutrality": {
          "type": "bool",
          "value": "true",
        },
      },
    }),
    ComponentType.TOGGLE_SWITCH_4AXES:
        ComponentSetting.fromJSON("Toggle 4-axes Switch", {
      "component_type": ComponentType.TOGGLE_SWITCH_4AXES.toString(),
      "x": 0,
      "y": 0,
      "width": 1,
      "height": 1,
      "target_inputs": [17, 18, 19, 20],
      "settings": {
        "display-name": {
          "type": "String",
          "value": "SLIDR",
        },
        "use-neutrality": {
          "type": "bool",
          "value": "true",
        },
      },
    }),
  };

  void insetDefault(ComponentSetting componentSetting) =>
      this.defaultSettingsMap[componentSetting.componentType].settings.forEach(
          (key, val) => componentSetting.settings.putIfAbsent(key, () => val));
}
