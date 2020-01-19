import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_button.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_hat_switch.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_slider.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_toggle_button.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component_toggle_switch.dart';
import 'package:flutter/cupertino.dart';

enum ComponentType {
  SLIDER,
  BUTTON,
  TOGGLE_BUTTON,
  TOGGLE_SWITCH,
  HAT_SWITCH,
}

class ComponentDefinition {
  final int minWidth;
  final int minHeight;
  final int minTargetInputs;

  final Map<String, dynamic> defaultSettings;

  final Component Function(ComponentSetting componentSetting, double blockWidth, double blockHeight) build;

  ComponentDefinition({
    @required this.minWidth,
    @required this.minHeight,
    @required this.minTargetInputs,
    @required this.defaultSettings,
    @required this.build,
  });
}

// ignore: non_constant_identifier_names
final Map<ComponentType, ComponentDefinition> COMPONENT_DEFINITION = {
  ComponentType.SLIDER: ComponentDefinition(minWidth: 1, minHeight: 1, minTargetInputs: 1, defaultSettings: {
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
  }, build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) =>
      ComponentSlider(
        componentSetting: componentSetting,
        blockWidth: blockWidth,
        blockHeight: blockHeight,
      )
  ),

  ComponentType.BUTTON: ComponentDefinition(minWidth: 1, minHeight: 1, minTargetInputs: 1, defaultSettings: {
    "display-name": {
      "type": "String",
      "value": "BUTTN",
    },

    "button-text": {
      "type": "String",
      "value": "BTN",
    }
  }, build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) =>
      ComponentButton(
        componentSetting: componentSetting,
        blockWidth: blockWidth,
        blockHeight: blockHeight,
      )
  ),

  ComponentType.TOGGLE_BUTTON: ComponentDefinition(minWidth: 1, minHeight: 1, minTargetInputs: 1, defaultSettings: {
    "display-name": {
      "type": "String",
      "value": "TOGLE",
    },

    "button-text": {
      "type": "String",
      "value": "TGL",
    }
  }, build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) =>
      ComponentToggleButton(
        componentSetting: componentSetting,
        blockWidth: blockWidth,
        blockHeight: blockHeight,
      )
  ),

  ComponentType.TOGGLE_SWITCH: ComponentDefinition(minWidth: 1, minHeight: 1, minTargetInputs: 1, defaultSettings: {
    "display-name": {
      "type": "String",
      "value": "SWTCH",
    },
  }, build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) =>
      ComponentToggleSwitch(
        componentSetting: componentSetting,
        blockWidth: blockWidth,
        blockHeight: blockHeight,
      )
  ),

  ComponentType.HAT_SWITCH: ComponentDefinition(minWidth: 1, minHeight: 1, minTargetInputs: 1, defaultSettings: {
    "display-name": {
      "type": "String",
      "value": "HAT",
    },
  }, build: (ComponentSetting componentSetting, double blockWidth, double blockHeight) =>
      ComponentHatSwitch(
        componentSetting: componentSetting,
        blockWidth: blockWidth,
        blockHeight: blockHeight,
      )
  ),

};

ComponentSetting getDefaultComponentSetting(
    ComponentType componentType, {
      String name = "Unnamed conponent",
      @required int x,
      @required int y,
      @required int width,
      @required int height,
      List<int> targetInputs = const [-1, -1, -1, -1],
      Map<String, String> inserts,
    }) {
  ComponentSetting componentSetting = ComponentSetting.fromJSON(name, {
    "component_type": componentType.toString(),

    "x": x,
    "y": y,
    "width": width,
    "height": height,

    "target_inputs": targetInputs,

    "settings": COMPONENT_DEFINITION[componentType].defaultSettings,
  });

  if (inserts != null) inserts.forEach((key, val) => componentSetting.settings[key].setValue(val));
  return componentSetting;
}
