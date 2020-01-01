import 'package:VirtualFlightThrottle/data/data_global_settings.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';

class PageSettings extends StatefulWidget {
  PageSettings({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageSettingsState();

}

class _PageSettingsState extends DynamicDirectionState<PageSettings> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future saveSettings() async {
    final form = this._formKey.currentState;
    if (form.validate()) {
      form.save();
    }
  }

  void resetSettings() {
    GlobalSettings.resetGlobalSettings();
    _formKey.currentState.setState(() {});
    _formKey.currentState.reset();
  }

  CardSettingsText _buildStringSection(String settingName, bool required, String Function(String) validator) {
    return CardSettingsText(
      label: GlobalSettings.settingsMap[settingName].settingName,
      hintText: GlobalSettings.settingsMap[settingName].defaultValue,
      initialValue: GlobalSettings.settingsMap[settingName].value,
      requiredIndicator: required ? Text("*", style: TextStyle(color: Colors.red)) : Text(""),
      autovalidate: true,
      validator: validator,

      onSaved: (val) => GlobalSettings.settingsMap[settingName].value = val,
    );
  }

  CardSettingsSwitch _buildSwitchSection(String settingName) {
    return CardSettingsSwitch(
      label: GlobalSettings.settingsMap[settingName].settingName,
      initialValue: GlobalSettings.settingsMap[settingName].value,

      onSaved: (val) => GlobalSettings.settingsMap[settingName].value = val,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Settigs"), // TODO: i8n needed
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
//          IconButton( // TODO: implement swap initial-value
//            icon: Icon(Icons.refresh),
//            onPressed: this.resetSettings,
//          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: this.saveSettings,
          )
        ],
      ),
      body: Form(
        key: this._formKey,
        child: CardSettings.sectioned(
          labelWidth: 150,
          children: <CardSettingsSection>[
            CardSettingsSection(
              header: CardSettingsHeader(
                label: "User Account",
              ),
              children: <Widget>[
                this._buildStringSection("user-name", false, (val) {
                  if ((!new RegExp("^[a-zA-Z0-9-._]{3,20}\$").hasMatch(val)) && val != "")
                    return "please review your account name."; // TODO: i8n needed
                  else return null;
                }),
                this._buildStringSection("user-pwd", false, (_) => null),
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: "UI Option",
              ),
              children: <Widget>[
                this._buildSwitchSection("hide-top-bar"),
                this._buildSwitchSection("hide-home-key"),
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: "Network",
              ),
              children: <Widget>[
                this._buildSwitchSection("auto-connection"),
              ],
            )
          ],
        ),
      ),
    );
  }

}