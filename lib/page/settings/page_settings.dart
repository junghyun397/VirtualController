import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:VirtualFlightThrottle/generated/l10n.dart';
import 'package:VirtualFlightThrottle/main.dart';
import 'package:VirtualFlightThrottle/network/network_manager.dart';
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
          title: Text(S.of(context).pageSettings_resetDialog_title),
          content: Text(S.of(context).pageSettings_resetDialog_content),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).pageSettings_resetDialog_cancel),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text(S.of(context).pageSettings_resetDialog_ok),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, String category) {
    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.light, accentColor: Theme.of(context).primaryColor),
      child: CardSettingsHeader(label: category),
    );
  }

  CardSettingsInstructions _buildInstruction(BuildContext context, SettingsType settingsType) {
    return CardSettingsInstructions(
      text: AppSettings().settingsMap[settingsType].getL10nDescription(context),
    );
  }

  CardSettingsInt _buildIntSection(BuildContext context, SettingsType settingsType, String unitLabel) {
    return CardSettingsInt(
        label: AppSettings().settingsMap[settingsType].getL10nName(context),
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

  CardSettingsText _buildStringSection(BuildContext context, SettingsType settingsType, bool required, String Function(String) validator) {
    return CardSettingsText(
      label: AppSettings().settingsMap[settingsType].getL10nName(context),
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

  CardSettingsPassword _buildPasswordSection(BuildContext context, SettingsType settingsType, String Function(String) validator) {
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

  CardSettingsSwitch _buildSwitchSection(BuildContext context, SettingsType settingsType, {void Function() afterChanged}) {
    return CardSettingsSwitch(
      label: AppSettings().settingsMap[settingsType].getL10nName(context),
      initialValue: AppSettings().settingsMap[settingsType].value,
      onChanged: (val) {
        setState(() {
          AppSettings().settingsMap[settingsType].value = val;
          SQLite3Helper().insertSettings(settingsType);
          if (afterChanged != null) afterChanged();
        });
      }
    );
  }

  CardSettingsListPicker _buildListPickerSection(SettingsType settingsType, List<String> values) {
    return CardSettingsListPicker(
      label: AppSettings().settingsMap[settingsType].getL10nName(context),
      initialValue: AppSettings().settingsMap[settingsType].value.toString(),
      autovalidate: true,
      options: values,
      values: values,
      onChanged: (val) {
        setState(() {
          AppSettings().settingsMap[settingsType].setValue(val);
          SQLite3Helper().insertSettings(settingsType);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(S.of(context).pageSettings_title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, Routes.PAGE_ABOUT),
            tooltip: "About App",
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => this._resetSettings(context),
            tooltip: "Reset settings",
          ),
        ],
      ),
      body: Form(
        child: CardSettings.sectioned(
          labelWidth: 150,
          children: <CardSettingsSection>[
            CardSettingsSection(
              header: this._buildHeader(context, S.of(context).pageSettings_section_userAccount),
              children: <Widget>[
                this._buildInstruction(context, SettingsType.USER_NAME),
                this._buildStringSection(context, SettingsType.USER_NAME, false, (val) {
                  if ((!new RegExp("^[a-zA-Z0-9-._]{3,20}\$").hasMatch(val)) && val != "")
                    return "Only alphabets and numbers are allowed.";
                  else return null;
                }),

                this._buildInstruction(context, SettingsType.USER_PWD),
                this._buildPasswordSection(context, SettingsType.USER_PWD, (val) {
                  if (val.length != 0 && val.length < 5)
                    return "Only more than 4 characters are allowed.";
                  else return null;
                }),
              ],
            ),
            CardSettingsSection(
              header: this._buildHeader(context, S.of(context).pageSettings_section_network),
              children: <Widget>[
                this._buildInstruction(context, SettingsType.NETWORK_TYPE),
                this._buildListPickerSection(SettingsType.NETWORK_TYPE,
                    AppNetworkManager().getAvailableInterfaceList().map((val) => val.toString()).toList()),

                this._buildInstruction(context, SettingsType.AUTO_CONNECTION),
                this._buildSwitchSection(context, SettingsType.AUTO_CONNECTION),

                this._buildInstruction(context, SettingsType.NETWORK_TIMEOUT),
                this._buildIntSection(context, SettingsType.NETWORK_TIMEOUT, "ms"),
              ],
            ),
            CardSettingsSection(
              header: this._buildHeader(context, S.of(context).pageSettings_section_UIOption),
              children: <Widget>[
                this._buildInstruction(context, SettingsType.USE_DARK_THEME),
                this._buildSwitchSection(context, SettingsType.USE_DARK_THEME, afterChanged: () =>
                    VirtualThrottleApp.themeStreamController.add(null)),

                this._buildInstruction(context, SettingsType.HIDE_TOP_BAR),
                this._buildSwitchSection(context, SettingsType.HIDE_TOP_BAR),

                this._buildInstruction(context, SettingsType.HIDE_HOME_KEY),
                this._buildSwitchSection(context, SettingsType.HIDE_HOME_KEY),

                this._buildInstruction(context, SettingsType.USE_VIBRATION),
                this._buildSwitchSection(context, SettingsType.USE_VIBRATION),

                this._buildInstruction(context, SettingsType.USE_WAKE_LOCK),
                this._buildSwitchSection(context, SettingsType.USE_WAKE_LOCK),

                this._buildInstruction(context, SettingsType.USE_BACKGROUND_TITLE),
                this._buildSwitchSection(context, SettingsType.USE_BACKGROUND_TITLE),
              ],
            ),
          ],
        ),
      ),
    );
  }

}