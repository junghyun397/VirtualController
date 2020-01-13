import 'package:VirtualFlightThrottle/data/data_app_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/routes.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';

class PageSettings extends StatefulWidget {
  PageSettings({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageSettingsState();
}

class _PageSettingsState extends DynamicDirectionState<PageSettings> {

  void _resetSettings(BuildContext context) async {
    if (!await _showResetSettingsDialog(context)) return;
    AppSettings().resetGlobalSettings();
    Navigator.pop(context);
    Navigator.pushNamed(context, Routes.PAGE_SETTING);
  }

  Future<bool> _showResetSettingsDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reset Settings"),
          content: const Text("Reset settings?"),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  CardSettingsInstructions _buildInstruction(SettingsType settingsType) {
    return CardSettingsInstructions(
      text: AppSettings().settingsMap[settingsType].description,
    );
  }

  CardSettingsInt _buildIntSection(SettingsType settingsType, String unitLabel) {
    return CardSettingsInt(
        label: AppSettings().settingsMap[settingsType].settingName,
        initialValue: AppSettings().settingsMap[settingsType].value,
        unitLabel: unitLabel,
        onChanged: (val) {
          setState(() {
            AppSettings().settingsMap[settingsType].value = val;
            SQLite3Helper().insertSettings(settingsType);
          });
        }
    );
  }

  CardSettingsText _buildStringSection(SettingsType settingsType, bool required, String Function(String) validator) {
    return CardSettingsText(
      label: AppSettings().settingsMap[settingsType].settingName,
      hintText: AppSettings().settingsMap[settingsType].defaultValue,
      initialValue: AppSettings().settingsMap[settingsType].value,
      requiredIndicator: required ? Text("*", style: TextStyle(color: Colors.red)) : Text(""),
      autovalidate: true,
      validator: validator,
      onChanged: (val) {
        setState(() {
          AppSettings().settingsMap[settingsType].value = val;
          SQLite3Helper().insertSettings(settingsType);
        });
      },
    );
  }

  CardSettingsPassword _buildPasswordSection(SettingsType settingsType, String Function(String) validator) {
    return CardSettingsPassword(
      initialValue: AppSettings().settingsMap[settingsType].value,
      autovalidate: true,
      validator: validator,
      onChanged: (val) {
        setState(() {
          AppSettings().settingsMap[settingsType].value = val;
          SQLite3Helper().insertSettings(settingsType);
        });
      },
    );
  }

  CardSettingsListPicker _buildListPickerSection(SettingsType settingsType) {
    return CardSettingsListPicker(
      label: AppSettings().settingsMap[settingsType].settingName,
      initialValue: AppSettings().settingsMap[settingsType].value.toString(),
      autovalidate: true,
      options: <String>["WiFi", "Bluetooth"],
      values: <String>[NetworkType.WIFI.toString(), NetworkType.BLUETOOTH.toString()],
      onChanged: (val) {
        setState(() {
          AppSettings().settingsMap[settingsType].setValue(val);
          SQLite3Helper().insertSettings(settingsType);
        });
      },
    );
  }

  CardSettingsSwitch _buildSwitchSection(SettingsType settingsType) {
    return CardSettingsSwitch(
      label: AppSettings().settingsMap[settingsType].settingName,
      initialValue: AppSettings().settingsMap[settingsType].value,
      onChanged: (val) {
        setState(() {
          AppSettings().settingsMap[settingsType].value = val;
          SQLite3Helper().insertSettings(settingsType);
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Settings"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => this._resetSettings(context),
          ),
        ],
      ),
      body: Form(
        child: CardSettings.sectioned(
          labelWidth: 150,
          children: <CardSettingsSection>[
            CardSettingsSection(
              header: CardSettingsHeader(label: "User Account"),
              children: <Widget>[
                this._buildInstruction(SettingsType.USER_NAME),
                this._buildStringSection(SettingsType.USER_NAME, false, (val) {
                  if ((!new RegExp("^[a-zA-Z0-9-._]{3,20}\$").hasMatch(val)) && val != "")
                    return "Only alphabets and numbers are allowed.";
                  else return null;
                }),
                this._buildInstruction(SettingsType.USER_PWD),
                this._buildPasswordSection(SettingsType.USER_PWD, (val) {
                  if (val.length != 0 && val.length < 5)
                    return "Only more than 4 characters are allowed.";
                  else return null;
                }),
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(label: "Network"),
              children: <Widget>[
                // this._buildInstruction(SettingsType.NETWORK_TYPE),
                // this._buildListPickerSection(SettingsType.NETWORK_TYPE),

                this._buildInstruction(SettingsType.AUTO_CONNECTION),
                this._buildSwitchSection(SettingsType.AUTO_CONNECTION),

                this._buildInstruction(SettingsType.NETWORK_TIMEOUT),
                this._buildIntSection(SettingsType.NETWORK_TIMEOUT, "ms"),
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(label: "UI Option"),
              children: <Widget>[
                this._buildInstruction(SettingsType.HIDE_TOP_BAR),
                this._buildSwitchSection(SettingsType.HIDE_TOP_BAR),

                this._buildInstruction(SettingsType.HIDE_HOME_KEY),
                this._buildSwitchSection(SettingsType.HIDE_HOME_KEY),

                this._buildInstruction(SettingsType.USE_VIBRATION),
                this._buildSwitchSection(SettingsType.USE_VIBRATION),
              ],
            ),
          ],
        ),
      ),
    );
  }

}