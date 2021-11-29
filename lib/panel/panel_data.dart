import 'package:vfcs/panel/component/component_data.dart';

class PanelData {

  late String name;

  late int date;

  late int width, height;

  late Map<String, ComponentData> components;

  PanelData({required this.name, required this.date, required this.width, required this.height, required this.components});

  factory PanelData.fromJSON(String name, Map<String, dynamic> json) =>
      PanelData(
        name: name,
        date: json["date"],
        width: json["width"],
        height: json["height"],
        components: (json["components"] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, ComponentData.fromJSON(key, value))),
      );

  Map<String, dynamic> toJSON() =>
      {
        "date": this.date,
        "width": this.width,
        "height": this.height,
        "components": this.components.map((key, value) => MapEntry(key, value.toJSON())),
      };
  
}