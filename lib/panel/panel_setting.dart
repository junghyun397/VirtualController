import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';

class PanelSetting {
  String name;

  int width, height;

  Map<String, ComponentSetting> components = Map<String, ComponentSetting>();

  PanelSetting.fromJSON(this.name, Map<String, dynamic> json) {
    this.width = json["width"];
    this.height = json["height"];

    json["components"].forEach((key, val) => this.components[key] = ComponentSetting.fromJSON(key, val));
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> result = Map<String, dynamic>();

    result["width"] = this.width;
    result["height"] = this.height;

    Map<String, dynamic> data = Map<String, dynamic>();

    this.components.forEach((key, val) => data[key] = val.toJSON());

    result["components"] = data;

    return result;
  }
}