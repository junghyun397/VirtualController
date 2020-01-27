import 'dart:convert';

import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        label: "Panel width",
        unitLabel: "blocks",
        requiredIndicator: Text("*", style: TextStyle(color: Colors.red)),
        initialValue: this._maxSize.a,
        autovalidate: true,
        validator: (val) {
          if (val != null && val <= this._maxSize.a) return null;
          else return "This device allows up to ${this._maxSize.a} widths.";
        },
        onChanged: (val) => this._panelSetting.width = val,
      ),
      CardSettingsInt(
        label: "Panel height",
        unitLabel: "blocks",
        requiredIndicator: Text("*", style: TextStyle(color: Colors.red)),
        initialValue: this._maxSize.b,
        autovalidate: true,
        validator: (val) {
          if (val != null && val <= this._maxSize.b) return null;
          else return "This device allows up to ${this._maxSize.b} height.";
        },
        onChanged: (val) => this._panelSetting.height = val,
      ),
    ];
    else return [
      CardSettingsParagraph(
        label: "JSON data",
        maxLength: 999999999999999,
        showCounter: false,
        autovalidate: true,
        validator: (val) {
          try {
            this._panelSetting = PanelSetting.fromJSON(this._name, jsonDecode(val));
            if (this._panelSetting.width > this._maxSize.a || this._panelSetting.height > this._maxSize.b) return "This panel is larger than the maximum size supported by this device.";
            else return null;
          } catch(e) {
            return "Fail to parse panel from JSON data.";
          }
        },
      )
    ];
  }

  @override
  void initState() {
    this._jsonMode = widget.jsonMode;
    this._name = "Unnamed Panel ${DateTime.now().toIso8601String().substring(0, 19)}";
    this._maxSize = PanelUtility.getMaxPanelSize(UtilitySystem.fullScreenSize);
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
                  label: "Panel Preferences",
                ),
                children: [
                  CardSettingsText(
                    maxLength: 35,
                    label: "Panel name",
                    hintText: this._name,
                    initialValue: "",
                    autovalidate: true,
                    validator: (val) {
                      if (val.length > 35 && val != "") return "max 35 word.";
                      else return null;
                    },
                    onChanged: (val) => this._panelSetting.name = val,
                  ),
                  ...this._buildNewPanelDataArea(context),
                ],
              ),
              CardSettingsSection(
                header: CardSettingsHeader(
                  label: "Action",
                ),
                children: [
                  CardSettingsButton(
                    label: "BUILD",
                    backgroundColor: Colors.green,
                    isDestructive: true,
                    onPressed: () {
                      if (this._formKey.currentState.validate()) Navigator.pop(context, this._panelSetting);
                      else Fluttertoast.showToast(
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
                    label: "CENCLE",
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