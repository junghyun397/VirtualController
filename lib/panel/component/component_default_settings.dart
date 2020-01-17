import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';

// ignore: missing_return
ComponentSetting getDefaultComponentSetting(
  ComponentType componentType, {
  int x,
  int y,
  int width,
  int height,
  List<int> targetInputs = const [-1],
}) {
  switch (componentType) {
    case ComponentType.SLIDER:
      return ComponentSetting.fromJSON("Slider", {
        "component_type": ComponentType.SLIDER.toString(),

        "x": x,
        "y": y,
        "width": width,
        "height": height,

        "target_inputs": targetInputs,

        "settings": {
          "display-name": {
            "type": "String",
            "value": "SLIDR",
          },

          "range": {
            "type": "double",
            "value": "100.0",
          },
          "use-int-range": {
            "type": "bool",
            "value": "false",
          },
          "unit-name": {
            "type": "String",
            "value": "v",
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
            "value": "[10.0, 20.0, 30.0]",
          },
        },
      });
    case ComponentType.BUTTON:
      return ComponentSetting.fromJSON("Button", {
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
      });
    case ComponentType.SWITCH:
      return ComponentSetting.fromJSON("Switch", {
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
      });
    case ComponentType.TOGGLE_BUTTON:
      return ComponentSetting.fromJSON("Toggle button", {
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
      });
    case ComponentType.TOGGLE_SWITCH_2AXES:
      return ComponentSetting.fromJSON("Toggle 2-axes Switch", {
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
      });
    case ComponentType.TOGGLE_SWITCH_4AXES:
      return ComponentSetting.fromJSON("Toggle 4-axes Switch", {
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
      });
    default:
      ComponentSetting.fromJSON("Button", {
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
      });
  }
}

void insertDefaultSettingData(ComponentSetting componentSetting) =>
    getDefaultComponentSetting(componentSetting.componentType).settings.forEach((key, val) =>
        componentSetting.settings.putIfAbsent(key, () => val.copy()));
