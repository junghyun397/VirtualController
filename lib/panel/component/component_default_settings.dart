import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:flutter/cupertino.dart';

ComponentSetting getDefaultComponentSetting(
  ComponentType componentType, {
  @required int x,
  @required int y,
  @required int width,
  @required int height,
  List<int> targetInputs = const [-1, -1, -1, -1],
  Map<String, String> inserts,
}) {
  Map<String, dynamic> settings;

  switch (componentType) {
    case ComponentType.SLIDER:
      settings = {
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
          "value": "[]",
        },
      };
      break;
    case ComponentType.BUTTON:
      settings = {
        "display-name": {
          "type": "String",
          "value": "BUTTN",
        },

        "button-text": {
          "type": "String",
          "value": "BTN",
        }
      };
      break;
    case ComponentType.TOGGLE_BUTTON:
      settings = {
        "display-name": {
          "type": "String",
          "value": "TOGLE",
        },

        "button-text": {
          "type": "String",
          "value": "TGL",
        }
      };
      break;
    case ComponentType.TOGGLE_SWITCH:
      settings = {
        "display-name": {
          "type": "String",
          "value": "SWTCH",
        },
      };
      break;
    case ComponentType.HAT_SWITCH:
      settings = {
        "display-name": {
          "type": "String",
          "value": "HAT",
        },
      };
      break;
  }

  ComponentSetting componentSetting = ComponentSetting.fromJSON("Unnamed conponent", {
    "component_type": componentType.toString(),

    "x": x,
    "y": y,
    "width": width,
    "height": height,

    "target_inputs": targetInputs,

    "settings": settings,
  });

  if (inserts != null) inserts.forEach((key, val) => componentSetting.settings[key].setValue(val));

  return componentSetting;
}
