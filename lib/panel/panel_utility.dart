import 'dart:ui';

import 'package:vfcs/network/network_interface.dart';
import 'package:vfcs/panel/component/component_definition.dart';
import 'package:vfcs/panel/panel_data.dart';
import 'package:vfcs/utility/utility_dart.dart';

class PanelUtility {

  static const double MIN_BLOCK_WIDTH = 80.0;
  static const double MIN_BLOCK_HEIGHT = 80.0;

  static const double TOP_MARGIN = 5;

  static bool canBuildPanelPerfectly(PanelData panelSetting, Size screenSize) =>
      screenSize.width / panelSetting.width < MIN_BLOCK_WIDTH || (screenSize.height - TOP_MARGIN) / panelSetting.height < MIN_BLOCK_HEIGHT;

  static Pair<int, int> getMaxPanelSize(Size screenSize) =>
      Pair(screenSize.width ~/ MIN_BLOCK_WIDTH, screenSize.height ~/ MIN_BLOCK_HEIGHT);

  static Size getBlockSize(PanelData panelSetting, Size screenSize, {double topMargin = TOP_MARGIN}) =>
      Size(screenSize.width / panelSetting.width, (screenSize.height - topMargin) / panelSetting.height);

  static String findNewName(PanelData panelSetting, ComponentType componentType) {
    for (int idx = 1; idx < 100; idx ++) {
      if (!panelSetting.components.containsKey("${COMPONENT_DEFINITION[componentType]!.shortName}#$idx"))
        return "${COMPONENT_DEFINITION[componentType]!.shortName}#$idx";
    }
    return "UNNAMED";
  }

  static String findNewLabel(PanelData panelSetting, ComponentType componentType) {
    for (int idx = 1; idx < 100; idx ++) {
      bool include = false;
      panelSetting.components.entries.forEach((val) {
        if (val.value.settings[ComponentSettingType.LABEL]!.value == "${COMPONENT_DEFINITION[componentType]!.labelName}$idx")
          include = true;
      });
      if (!include)
        return "${COMPONENT_DEFINITION[componentType]!.labelName}$idx";
    }
    return "NAME";
  }

  static List<int> findTargetInput(PanelData panelSetting, ComponentType componentType) {
    Set<int> usedInputs = Set<int>();
    panelSetting.components.forEach((key, val) {
      if (COMPONENT_DEFINITION[componentType]!.outputType == COMPONENT_DEFINITION[val.componentType]!.outputType)
        usedInputs.addAll(val.targetInputs);
    });
    Set<int> diff = Set.from(Iterable.generate(
      COMPONENT_DEFINITION[componentType]!.outputType == ComponentOutputType.ANALOGUE
          ? NetworkProtocol.ANALOGUE_INPUT_COUNT
          : NetworkProtocol.DIGITAL_INPUT_COUNT,
          (idx) => COMPONENT_DEFINITION[componentType]!.outputType == ComponentOutputType.ANALOGUE
          ? idx + 1 : idx + NetworkProtocol.ANALOGUE_INPUT_COUNT + 1,
    )).cast<int>().difference(usedInputs);
    if (diff.length < COMPONENT_DEFINITION[componentType]!.requiredInputs)
      return List.filled(COMPONENT_DEFINITION[componentType]!.requiredInputs, 0);
    return diff.toList().sublist(0, COMPONENT_DEFINITION[componentType]!.requiredInputs);
  }

}