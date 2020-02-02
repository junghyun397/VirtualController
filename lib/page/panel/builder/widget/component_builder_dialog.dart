import 'dart:convert';

import 'package:VirtualFlightThrottle/generated/l10n.dart';
import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ComponentBuilderDialog extends StatefulWidget {

  final ComponentSetting targetComponentSetting;

  ComponentBuilderDialog({Key key, @required this.targetComponentSetting}) : super(key: key);

  @override
  State<ComponentBuilderDialog> createState() => _ComponentBuilderDialogState();

}

class _ComponentBuilderDialogState extends State<ComponentBuilderDialog> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTargetInputSection(BuildContext context, bool isAnalogue, int index) {
    if (isAnalogue) return CardSettingsNumberPicker(
      label: S.of(context).dialogComponentBuilder_target_axes(index + 1),
      initialValue: widget.targetComponentSetting.targetInputs[index],
      min: 0,
      max: NetworkProtocol.ANALOGUE_INPUT_COUNT,
      onChanged: (val) => widget.targetComponentSetting.targetInputs[index] = val,
    );
    else return CardSettingsNumberPicker(
      label: S.of(context).dialogComponentBuilder_target_button(index + 1),
      initialValue: widget.targetComponentSetting.targetInputs[index] == 0
          ? 0 : widget.targetComponentSetting.targetInputs[index] - NetworkProtocol.ANALOGUE_INPUT_COUNT + 1,
      min: 0,
      max: NetworkProtocol.DIGITAL_INPUT_COUNT,
      onChanged: (val) => widget.targetComponentSetting.targetInputs[index] = val == 0
          ? 0 : val + NetworkProtocol.ANALOGUE_INPUT_COUNT - 1,
    );
  }

  Widget _buildComponentSettingDescription(BuildContext context, ComponentSettingData componentSettingData) =>
      CardSettingsInstructions(text: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].getL10nDescription(context));

  // ignore: missing_return
  Widget _buildComponentSettingSection(BuildContext context, ComponentSettingData componentSettingData) {
    switch (componentSettingData.type.toString()) {
      case "bool":
        return CardSettingsSwitch(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].getL10nComponentName(context),
          initialValue: componentSettingData.value,
          validator: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].validator,
          onSaved: (val) => componentSettingData.setValue(val.toString()),
        );
      case "int":
        return CardSettingsInt(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].getL10nComponentName(context),
          initialValue: componentSettingData.value,
          validator: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].validator,
          onSaved: (val) => componentSettingData.setValue(val.toString()),
        );
      case "double":
        return CardSettingsDouble(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].getL10nComponentName(context),
          initialValue: componentSettingData.value,
          validator: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].validator,
          onSaved: (val) => componentSettingData.setValue(val.toString()),
        );
      case "CastList<dynamic, double>":
        return CardSettingsText(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].getL10nComponentName(context),
          initialValue: componentSettingData.value.toString(),
          maxLength: 500,
          maxLengthEnforced: false,
          validator: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].validator,
          onSaved: (val) {
            List<double> rs = List<double>();
            jsonDecode(val).forEach((val) => rs.add(double.parse(val.toString())));
            componentSettingData.setValue(rs.toString());
          },
        );
      case "String":
        return CardSettingsText(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].getL10nComponentName(context),
          initialValue: componentSettingData.value,
          validator: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].validator,
          onSaved: (val) => componentSettingData.setValue(val),
        );
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
          autovalidate: true,
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
                  for (int idx = 0; idx < COMPONENT_DEFINITION[widget.targetComponentSetting.componentType].needInputs; idx++)
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
                      if (this._formKey.currentState.validate()) {
                        this._formKey.currentState.save();
                        Navigator.pop(context, true);
                      } else Fluttertoast.showToast(
                        msg: S.of(context).dialogComponentBuilder_toast_invalidSettings,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
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