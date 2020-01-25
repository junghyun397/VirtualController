import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';

class PanelBuilderDialogController {

  final bool jsonMode;

  String name;
  Pair<int, int> maxSize;
  PanelSetting panelSetting;

  PanelBuilderDialogController(this.jsonMode) {
    this.name = "Unnamed Panel ${DateTime.now().toIso8601String().substring(0, 19)}";
    this.maxSize = PanelUtility.getMaxPanelSize(UtilitySystem.fullScreenSize);
    if (!this.jsonMode) this.panelSetting = getBasicPanelSetting(name: this.name, width: this.maxSize.a, height: this.maxSize.b);
  }

}