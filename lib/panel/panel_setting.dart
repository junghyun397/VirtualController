import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';

class PanelSetting {
  String name;

  int width, height;

  Map<String, ComponentSetting> components = new Map<String, ComponentSetting>();

  PanelSetting.fromJSON(this.name, Map<String, dynamic> json) {
    this.width = json["width"];
    this.height = json["height"];

    json["components"].forEach((key, val) {
      this.components[key] = ComponentSetting.fromJSON(key, val);
    });
  }
}