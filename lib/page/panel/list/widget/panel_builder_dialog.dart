import 'dart:convert';

import 'package:VirtualFlightThrottle/generated/l10n.dart';
import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PanelBuilderDialog extends StatefulWidget {
  
  final bool jsonMode;

  const PanelBuilderDialog({Key key, this.jsonMode}) : super(key: key);

  @override
  State<PanelBuilderDialog> createState() => _PanelBuilderDialogState();

}

class _PanelBuilderDialogState extends State<PanelBuilderDialog> {

  bool _jsonMode;

  String _name;
  Pair<int, int> _maxSize;
  PanelSetting _panelSetting;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Widget> _buildNewPanelDataArea(BuildContext context) {
    if (!widget.jsonMode) return [
      CardSettingsInt(
        label: S.of(context).dialogPanelBuilder_panelPreferences_width,
        unitLabel: S.of(context).dialogPanelBuilder_panelPreferences_blocks,
        requiredIndicator: Text("*", style: TextStyle(color: Colors.red)),
        initialValue: this._maxSize.a,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (val) {
          if (val != null && val <= this._maxSize.a) return null;
          else return S.of(context).dialogPanelBuilder_panelPreferences_widthError(this._maxSize.a);
        },
        onChanged: (val) => this._panelSetting.width = val,
      ),
      CardSettingsInt(
        label: S.of(context).dialogPanelBuilder_panelPreferences_height,
        unitLabel: S.of(context).dialogPanelBuilder_panelPreferences_blocks,
        requiredIndicator: Text("*", style: TextStyle(color: Colors.red)),
        initialValue: this._maxSize.b,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (val) {
          if (val != null && val <= this._maxSize.b) return null;
          else return S.of(context).dialogPanelBuilder_panelPreferences_heightError(this._maxSize.b);
        },
        onChanged: (val) => this._panelSetting.height = val,
      ),
    ];
    else return [
      CardSettingsParagraph(
        label: S.of(context).dialogPanelBuilder_panelPreferences_jsonData,
        maxLength: 100000000,
        showCounter: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (val) {
          try {
            this._panelSetting = PanelSetting.fromJSON(this._name, jsonDecode(val));
            if (this._panelSetting.width > this._maxSize.a || this._panelSetting.height > this._maxSize.b)
              return S.of(context).dialogPanelBuilder_panelPreferences_jsonDataError_tooLarge;
            else return null;
          } catch(e) {
            return S.of(context).dialogPanelBuilder_panelPreferences_jsonDataError_failToParse;
          }
        },
      )
    ];
  }

  @override
  void initState() {
    this._jsonMode = widget.jsonMode;
    this._name = "Unnamed Panel ${DateTime.now().toIso8601String().substring(0, 19)}";
    this._maxSize = PanelUtility.getMaxPanelSize(SystemUtility.physicalSize);
    if (!this._jsonMode) this._panelSetting = getBasicPanelSetting(name: this._name, width: this._maxSize.a, height: this._maxSize.b);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Form(
          key: this._formKey,
          child: CardSettings.sectioned(
            shrinkWrap: true,
            showMaterialonIOS: true,
            children: <CardSettingsSection>[
              CardSettingsSection(
                header: CardSettingsHeader(
                  label: S.of(context).dialogPanelBuilder_panelPreferences_header,
                ),
                children: [
                  CardSettingsText(
                    maxLength: 35,
                    label: S.of(context).dialogPanelBuilder_panelPreferences_panelName,
                    hintText: this._name,
                    initialValue: "",
                    autovalidate: true,
                    validator: (val) {
                      if (val.length > 35 && val != "") return S.of(context).dialogPanelBuilder_panelPreferences_panelName_error;
                      else return null;
                    },
                    onChanged: (val) => this._panelSetting.name = val,
                  ),
                  ...this._buildNewPanelDataArea(context),
                ],
              ),
              CardSettingsSection(
                header: CardSettingsHeader(
                  label: S.of(context).dialogPanelBuilder_action_header,
                ),
                children: [
                  CardSettingsButton(
                    label: S.of(context).dialogPanelBuilder_action_build,
                    backgroundColor: Colors.green,
                    isDestructive: true,
                    onPressed: () {
                      if (this._formKey.currentState.validate()) Navigator.pop(context, this._panelSetting);
                      else SystemUtility.showToast(message: S.of(context).dialogPanelBuilder_toast_invalidSettings);
                    },
                  ),
                  CardSettingsButton(
                    label: S.of(context).dialogPanelBuilder_action_cancel,
                    backgroundColor: Colors.red,
                    isDestructive: true,
                    onPressed: () => Navigator.pop(context, null),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}