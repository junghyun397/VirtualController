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
    return CardSettingsNumberPicker(
      label: isAnalogue ? "Target axes" : "Target button ${index+1}",
      initialValue: widget.targetComponentSetting.targetInputs[index] + 1,
      min: 0,
      max: isAnalogue ? NetworkProtocol.ANALOGUE_INPUT_COUNT : NetworkProtocol.DIGITAL_INPUT_COUNT,
      onSaved: (val) => widget.targetComponentSetting.targetInputs[index] = val - 1,
    );
  }

  Widget _buildComponentSettingDescription(BuildContext context, ComponentSettingData componentSettingData) =>
      CardSettingsInstructions(text: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].description);

  // ignore: missing_return
  Widget _buildComponentSettingSection(BuildContext context, ComponentSettingData componentSettingData) {
    switch (componentSettingData.type.toString()) {
      case "bool":
        return CardSettingsSwitch(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].displaySettingName,
          initialValue: componentSettingData.value,
          onSaved: (val) => componentSettingData.setValue(val.toString()),
        );
      case "int":
        return CardSettingsInt(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].displaySettingName,
          initialValue: componentSettingData.value,
          onSaved: (val) => componentSettingData.setValue(val.toString()),
        );
      case "double":
        return CardSettingsDouble(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].displaySettingName,
          initialValue: componentSettingData.value,
          onSaved: (val) => componentSettingData.setValue(val.toString()),
        );
      case "CastList<dynamic, double>":
        return CardSettingsText(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].displaySettingName,
          initialValue: componentSettingData.value.toString(),
          onSaved: (val) => componentSettingData.setValue(val.toString()),
        );
      case "String":
        return CardSettingsText(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].displaySettingName,
          initialValue: componentSettingData.value,
          onSaved: (val) => componentSettingData.setValue(val.toString()),
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
                header: CardSettingsHeader(label: "Component Information"),
                children: [
                  CardSettingsText(
                    label: "Name",
                    initialValue: widget.targetComponentSetting.name,
                  ),
                  for (int idx = 0; idx < COMPONENT_DEFINITION[widget.targetComponentSetting.componentType].minTargetInputs; idx++)
                    this._buildTargetInputSection(context, widget.targetComponentSetting.componentType == ComponentType.SLIDER, idx),
                ],
              ),
              CardSettingsSection(
                header: CardSettingsHeader(label: "Component Perferences"),
                children: mixTwoList(
                  widget.targetComponentSetting.settings.entries.map((val) =>
                      this._buildComponentSettingDescription(context, val.value)).toList(),
                  widget.targetComponentSetting.settings.entries.map((val) =>
                      this._buildComponentSettingSection(context, val.value)).toList(),
                ),
              ),
              CardSettingsSection(
                header: CardSettingsHeader(
                  label: "Actions",
                ),
                children: [
                  CardSettingsButton(
                    label: "APPLY",
                    backgroundColor: Colors.green,
                    onPressed: () {
                      if (this._formKey.currentState.validate()) {
                        this._formKey.currentState.save();
                        Navigator.pop(context, true);
                      } else Fluttertoast.showToast(
                        msg: "Invalid setting exists",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    },
                  ),
                  CardSettingsButton(
                    label: "REMOVE",
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