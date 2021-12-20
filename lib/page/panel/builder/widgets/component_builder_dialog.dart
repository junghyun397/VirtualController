import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vfcs/generated/l10n.dart';
import 'package:vfcs/network/network_interface.dart';
import 'package:vfcs/panel/component/component_definition.dart';
import 'package:vfcs/panel/component/component_data.dart';
import 'package:vfcs/panel/component/component_settings.dart';
import 'package:vfcs/utility/utility_dart.dart';
import 'package:vfcs/utility/utility_system.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/widgets.dart';

class ComponentBuilderDialog extends StatefulWidget {

  final ComponentData targetComponentSetting;

  ComponentBuilderDialog({required Key key, required this.targetComponentSetting}) : super(key: key);

  @override
  State<ComponentBuilderDialog> createState() => _ComponentBuilderDialogState();

}

class _ComponentBuilderDialogState extends State<ComponentBuilderDialog> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CardSettingsWidget _buildTargetInputSection(BuildContext context, bool isAnalogue, int index) {
    if (isAnalogue) return CardSettingsNumberPicker(
      label: S.of(context).dialogComponentBuilder_target_axes(index + 1),
      initialValue: widget.targetComponentSetting.targetInputs[index],
      min: 0,
      max: NetworkProtocol.ANALOGUE_INPUT_COUNT,
      onChanged: (val) => widget.targetComponentSetting.targetInputs[index] = val!,
    );
    else return CardSettingsNumberPicker(
      label: S.of(context).dialogComponentBuilder_target_button(index + 1),
      initialValue: widget.targetComponentSetting.targetInputs[index] == 0
          ? 0 : widget.targetComponentSetting.targetInputs[index] - NetworkProtocol.ANALOGUE_INPUT_COUNT,
      min: 0,
      max: NetworkProtocol.DIGITAL_INPUT_COUNT,
      onChanged: (val) => widget.targetComponentSetting.targetInputs[index] = val == 0
          ? 0 : val! + NetworkProtocol.ANALOGUE_INPUT_COUNT,
    );
  }

  CardSettingsWidget _buildComponentSettingDescription(BuildContext context, ComponentSettingData componentSettingData) =>
      CardSettingsInstructions(text: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType]!.getL10nDescription(context));

  // ignore: missing_return
  CardSettingsWidget _buildComponentSettingSection(BuildContext context, ComponentSettingData componentSettingData) {
    switch (componentSettingData.type.toString()) {
      case "bool":
        return CardSettingsSwitch(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType]!.getL10nName(context),
          initialValue: componentSettingData.value,
          validator: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType]!.validator,
          onSaved: (val) => componentSettingData.setValue(val.toString()),
        );
      case "int":
        return CardSettingsInt(
        label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType]!.getL10nName(context),
          initialValue: componentSettingData.value,
          validator: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType]!.validator,
          onSaved: (val) => componentSettingData.setValue(val.toString()),
        );
      case "double":
        return CardSettingsDouble(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType]!.getL10nName(context),
          initialValue: componentSettingData.value,
          validator: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType]!.validator,
          onSaved: (val) => componentSettingData.setValue(val.toString()),
        );
      case "CastList<dynamic, double>":
        return CardSettingsText(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType]!.getL10nName(context),
          initialValue: componentSettingData.value.toString(),
          maxLength: 500,
          validator: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType]!.validator,
          onSaved: (val) =>
            componentSettingData.setValue(jsonDecode(val!).map((value) => double.parse(value.toString())).toString()),
        );
      case "String":
        return CardSettingsText(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType]!.getL10nName(context),
          initialValue: componentSettingData.value,
          validator: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType]!.validator,
          onSaved: (val) => componentSettingData.setValue(val!),
        );
      default:
        return CardSettingsText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Form(
          key: this._formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CardSettings.sectioned(
            labelWidth: 200,
            shrinkWrap: true,
            showMaterialonIOS: true,
            children: <CardSettingsSection>[
              CardSettingsSection(
                header: CardSettingsHeader(label: S.of(context).dialogComponentBuilder_componentInformation_header),
                children: [
//                  TODO: Implement safe name change
//                  CardSettingsText(
//                    label: "Name",
//                    initialValue: widget.targetComponentSetting.name,
//                    onChanged: (val) => widget.targetComponentSetting.name = val,
//                  ),
                  for (int idx = 0; idx < COMPONENT_DEFINITION[widget.targetComponentSetting.componentType]!.requiredInputs; idx++)
                    this._buildTargetInputSection(context, widget.targetComponentSetting.componentType == ComponentType.SLIDER, idx),
                ],
              ),
              CardSettingsSection(
                header: CardSettingsHeader(label: S.of(context).dialogComponentBuilder_componentPreferences_header),
                children: mixTwoList(
                  widget.targetComponentSetting.settings.entries.map((val) =>
                      this._buildComponentSettingDescription(context, val.value)).toList(),
                  widget.targetComponentSetting.settings.entries.map((val) =>
                      this._buildComponentSettingSection(context, val.value)).toList(),
                ),
              ),
              CardSettingsSection(
                header: CardSettingsHeader(
                  label: S.of(context).dialogComponentBuilder_action_header,
                ),
                children: [
                  CardSettingsButton(
                    label: S.of(context).dialogComponentBuilder_action_apply,
                    backgroundColor: Colors.green,
                    onPressed: () {
                      if (this._formKey.currentState!.validate()) {
                        this._formKey.currentState!.save();
                        Navigator.pop(context, true);
                      } else SystemUtility.showToast(S.of(context).dialogComponentBuilder_toast_invalidSettings);
                    },
                  ),
                  CardSettingsButton(
                    label: S.of(context).dialogComponentBuilder_action_remove,
                    isDestructive: true,
                    backgroundColor: Colors.red,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}