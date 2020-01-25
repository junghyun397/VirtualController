import 'dart:convert';

import 'package:VirtualFlightThrottle/page/panel/list/widget/panel_builder_dialog_controller.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PanelBuilderDialog extends StatefulWidget {
  
  final bool jsonMode;

  const PanelBuilderDialog({Key key, this.jsonMode}) : super(key: key);

  @override
  State<PanelBuilderDialog> createState() => _PanelBuilderDialogState();

}

class _PanelBuilderDialogState extends State<PanelBuilderDialog> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Widget> _buildNewPanelDataArea(BuildContext context, PanelBuilderDialogController controller) {
    if (!widget.jsonMode) return [
      CardSettingsInt(
        label: "Panel width",
        unitLabel: "blocks",
        requiredIndicator: Text("*", style: TextStyle(color: Colors.red)),
        initialValue: controller.maxSize.a,
        autovalidate: true,
        validator: (val) {
          if (val != null && val <= controller.maxSize.a) return null;
          else return "This device allows up to ${controller.maxSize.a} widths.";
        },
        onChanged: (val) => controller.panelSetting.width = val,
      ),
      CardSettingsInt(
        label: "Panel height",
        unitLabel: "blocks",
        requiredIndicator: Text("*", style: TextStyle(color: Colors.red)),
        initialValue: controller.maxSize.b,
        autovalidate: true,
        validator: (val) {
          if (val != null && val <= controller.maxSize.b) return null;
          else return "This device allows up to ${controller.maxSize.b} height.";
        },
        onChanged: (val) => controller.panelSetting.height = val,
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
            controller.panelSetting = PanelSetting.fromJSON(controller.name, jsonDecode(val));
            if (controller.panelSetting.width > controller.maxSize.a || controller.panelSetting.height > controller.maxSize.b) return "This panel is larger than the maximum size supported by this device.";
            else return null;
          } catch(e) {
            return "Fail to parse panel from JSON data.";
          }
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    PanelBuilderDialogController controller = PanelBuilderDialogController(widget.jsonMode);
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Provider<PanelBuilderDialogController>(
        create: (_) => controller,
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
                      hintText: controller.name,
                      initialValue: "",
                      autovalidate: true,
                      validator: (val) {
                        if (val.length > 35 && val != "") return "max 35 word.";
                        else return null;
                      },
                      onChanged: (val) => controller.panelSetting.name = val,
                    ),
                    ...this._buildNewPanelDataArea(context, controller),
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
                        if (this._formKey.currentState.validate()) Navigator.pop(context, controller.panelSetting);
                        else Fluttertoast.showToast(
                            msg: "Please check the incorrect settings.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.red,
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
      ),
    );
  }

}