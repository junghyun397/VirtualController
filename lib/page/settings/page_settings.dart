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

  void _resetSettings() {
    _formKey.currentState.setState(() {GlobalSettings.resetGlobalSettings();});
    _formKey.currentState.reset();
  }

  CardSettingsText _buildStringSection(SettingsType settingsType, bool required, String validatorRegex, String regexFail) {
    return CardSettingsText(
      label: GlobalSettings.settingsMap[settingsType].settingName,
      hintText: GlobalSettings.settingsMap[settingsType].defaultValue,
      initialValue: GlobalSettings.settingsMap[settingsType].value,
      requiredIndicator: required ? Text("*", style: TextStyle(color: Colors.red)) : Text(""),
      autovalidate: true,
      validator: validatorRegex == null ? (_) => null : (val) {
        if ((!new RegExp(validatorRegex).hasMatch(val)) && val != "")
          return regexFail;
        else return null;
      },

      onChanged: (val) {
        setState(() {GlobalSettings.settingsMap[settingsType].saveValue(val);});
      },
    );
  }

  CardSettingsSwitch _buildSwitchSection(SettingsType settingsType) {
    return CardSettingsSwitch(
      label: GlobalSettings.settingsMap[settingsType].settingName,
      initialValue: GlobalSettings.settingsMap[settingsType].value,

      onChanged: (val) {
        setState(() {GlobalSettings.settingsMap[settingsType].saveValue(val);});
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Settings"), // TODO: i8n needed
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: this._resetSettings,
          ),
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
                this._buildStringSection(SettingsType.USER_NAME, false,
                    "^[a-zA-Z0-9-._]{3,20}\$", "please review your account name."), // TODO: i8n needed
                this._buildStringSection(SettingsType.USER_PWD, false, null, null),
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: "UI Option",
              ),
              children: <Widget>[
                this._buildSwitchSection(SettingsType.HIDE_TOP_BAR),
                this._buildSwitchSection(SettingsType.HIDE_HOME_KEY),
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: "Network",
              ),
              children: <Widget>[
                this._buildSwitchSection(SettingsType.AUTO_CONNECTION),
              ],
            )
          ],
        ),
      ),
    );
  }

}