import 'package:VirtualFlightThrottle/data/data_app_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';

const String PAGE_SETTING_ROUTE = "/settings";

class PageSettings extends StatefulWidget {
  PageSettings({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageSettingsState();
}

class _PageSettingsState extends DynamicDirectionState<PageSettings> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetSettings(BuildContext context) async {
    if (!await _showResetSettingsDialog(context)) return;
    AppSettings().resetGlobalSettings();
    Navigator.pop(context);
    Navigator.pushNamed(context, "/settings");
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
        key: this._formKey,
        child: CardSettings.sectioned(
          labelWidth: 150,
          children: <CardSettingsSection>[
            CardSettingsSection(
              header: CardSettingsHeader(
                label: "User Account",
              ),
              children: <Widget>[
                this._buildInstruction(SettingsType.USER_NAME),
                this._buildStringSection(SettingsType.USER_NAME, false, (val) {
                  if ((!new RegExp("^[a-zA-Z0-9-._]{3,20}\$").hasMatch(val)) && val != "")
                    return "please review your account name.";
                  else return null;
                }),

                this._buildInstruction(SettingsType.USER_PWD),
                this._buildStringSection(SettingsType.USER_PWD, false, (_) => null),
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: "UI Option",
              ),
              children: <Widget>[
                this._buildInstruction(SettingsType.HIDE_TOP_BAR),
                this._buildSwitchSection(SettingsType.HIDE_TOP_BAR),

                this._buildInstruction(SettingsType.HIDE_HOME_KEY),
                this._buildSwitchSection(SettingsType.HIDE_HOME_KEY),
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: "Network",
              ),
              children: <Widget>[
                this._buildInstruction(SettingsType.AUTO_CONNECTION),
                this._buildSwitchSection(SettingsType.AUTO_CONNECTION),
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: "Hardware",
              ),
              children: <Widget>[
                this._buildInstruction(SettingsType.USE_VIBRATION),
                this._buildSwitchSection(SettingsType.USE_VIBRATION),
              ],
            )
          ],
        ),
      ),
    );
  }

}