import 'package:flutter/widgets.dart';
import 'package:vfcs/network/network_interface.dart';
import 'package:vfcs/panel/component/component_definition.dart';
import 'package:vfcs/panel/component/component_settings_definition.dart';
import 'package:vfcs/panel/panel_data.dart';
import 'package:vfcs/utility/utility_dart.dart';

class PanelUtility {

  static const double MIN_BLOCK_WIDTH = 80.0;
  static const double MIN_BLOCK_HEIGHT = 80.0;

  static const double BLOCK_MARGIN = 5;

  static bool canBuildPanelPerfectly(PanelData panelData, Size screenSize) =>
      screenSize.width / panelData.width < MIN_BLOCK_WIDTH || (screenSize.height - BLOCK_MARGIN) / panelData.height < MIN_BLOCK_HEIGHT;

  static Orientation? findPossibleOrientation(PanelData panelData, Size screenSize) =>
      !PanelUtility.canBuildPanelPerfectly(panelData, screenSize)
          ? (PanelUtility.canBuildPanelPerfectly(panelData, screenSize.flipped)
            ? Orientation.portrait
            : null)
          : Orientation.landscape;

  static Pair<int, int> getMaxPanelSize(Size screenSize) =>
      Pair(screenSize.width ~/ MIN_BLOCK_WIDTH, screenSize.height ~/ MIN_BLOCK_HEIGHT);

  static double getBlockSize(PanelData panelSetting, Size screenSize, {double margin = BLOCK_MARGIN}) =>
      (screenSize.height - margin) / panelSetting.height;

  static String findNewName(PanelData panelSetting, ComponentType componentType) {
    for (int idx = 1; idx < 100; idx ++) {
      if (!panelSetting.components.containsKey("${getComponentDefinition(componentType).shortName}#$idx"))
        return "${getComponentDefinition(componentType).shortName}#$idx";
    }
    return "UNNAMED";
  }

  static String findNewLabel(PanelData panelSetting, ComponentType componentType) {
    for (int idx = 1; idx < 100; idx ++) {
      bool include = false;
      panelSetting.components.values
          .firstWhere((value) => value.settings[ComponentSettingType.LABEL]!.value == "${getComponentDefinition(componentType).labelName}$idx");
      panelSetting.components.entries.forEach((val) {
        if (val.value.settings[ComponentSettingType.LABEL]!.value == "${getComponentDefinition(componentType).labelName}$idx")
          include = true;
      });
      if (!include) return "${getComponentDefinition(componentType).labelName}$idx";
    }
    return "NAME";
  }

  static List<int> findTargetInput(PanelData panelSetting, ComponentType componentType) {
    final Set<int> usedInputs = Set<int>();
    panelSetting.components.forEach((key, val) {
      if (getComponentDefinition(componentType).outputType == getComponentDefinition(val.componentType).outputType)
        usedInputs.addAll(val.targetInputs);
    });
    final Set<int> diff = Set.from(Iterable.generate(
      getComponentDefinition(componentType).outputType == ComponentOutputType.ANALOGUE
          ? NetworkProtocol.ANALOGUE_INPUT_COUNT
          : NetworkProtocol.DIGITAL_INPUT_COUNT,
          (idx) => getComponentDefinition(componentType).outputType == ComponentOutputType.ANALOGUE
          ? idx + 1 : idx + NetworkProtocol.ANALOGUE_INPUT_COUNT + 1,
    )).cast<int>().difference(usedInputs);
    if (diff.length < getComponentDefinition(componentType).requiredInputs)
      return List.filled(getComponentDefinition(componentType).requiredInputs, 0);
    return diff.toList().sublist(0, getComponentDefinition(componentType).requiredInputs);
  }

}