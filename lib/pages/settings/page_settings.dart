import 'package:vfcs/app_manager.dart';
import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/generated/l10n.dart';
import 'package:vfcs/network/network_manager.dart';
import 'package:vfcs/pages/orientation_page.dart';
import 'package:vfcs/routes.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageSettings extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _PageSettingsState();

}

class _PageSettingsState extends DynamicOrientationPage<PageSettings> {

  void _resetSettings(BuildContext context) async {
    if (!await _confirmResetViaDialog(context)) return;
    AppManager.byContext(context).settingProvider.resetGlobalSettings();
    Navigator.pop(context);
    Navigator.pushNamed(context, Routes.PAGE_SETTING);
  }

  Future<bool> _confirmResetViaDialog(BuildContext context) async =>
      Future.value(true);
  //   return await showDialog<bool>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(S.of(context).pageSettings_resetDialog_title),
  //         content: Text(S.of(context).pageSettings_resetDialog_content),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text(S.of(context).pageSettings_resetDialog_cancel),
  //             onPressed: () {
  //               Navigator.of(context).pop(false);
  //             },
  //           ),
  //           FlatButton(
  //             child: Text(S.of(context).pageSettings_resetDialog_ok),
  //             onPressed: () {
  //               Navigator.of(context).pop(true);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  CardSettingsHeader _buildHeader(BuildContext context, String category) =>
    CardSettingsHeader(label: category);

  CardSettingsInstructions _buildInstruction(BuildContext context, AppManager appManager, SettingType settingsType) =>
    CardSettingsInstructions(
      text: appManager.settingProvider.getSettingData(settingsType).getL10nDescription(context),
    );

  CardSettingsWidget _buildIntSection(BuildContext context, AppManager appManager, SettingType settingsType, String unitLabel) =>
    CardSettingsInt(
        label: appManager.settingProvider.getSettingData(settingsType).getL10nName(context),
        initialValue: appManager.settingProvider.getSettingData(settingsType).value,
        unitLabel: unitLabel,
        onChanged: (val) {
          setState(() {
            appManager.settingProvider.getSettingData(settingsType).value = val;
            appManager.databaseProvider.insertSettings(settingsType, appManager.settingProvider.getSettingData(settingsType));
          });
        }
    );

  CardSettingsWidget _buildStringSection(BuildContext context, AppManager appManager, SettingType settingsType, bool required, String? Function(String?)? validator) {
    final SettingData settingData = appManager.settingProvider.getSettingData(settingsType);
    return CardSettingsText(
      label: settingData.getL10nName(context),
      hintText: settingData.defaultValue,
      initialValue: settingData.value,
      requiredIndicator: required ? Text("*", style: TextStyle(color: Colors.red)) : Text(""),
      autovalidate: true,
      validator: validator,
      onChanged: (val) {
        setState(() {
          settingData.value = val;
          appManager.databaseProvider.insertSettings(settingsType, settingData);
        });
      },
    );
  }

  CardSettingsWidget _buildPasswordSection(BuildContext context, AppManager appManager, SettingType settingsType, String? Function(String?)? validator) {
    final SettingData settingData = appManager.settingProvider.getSettingData(settingsType);
    return CardSettingsPassword(
      initialValue: settingData.value,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: (val) {
        setState(() {
          settingData.value = val;
          appManager.databaseProvider.insertSettings(settingsType, settingData);
        });
      },
    );
  }

  CardSettingsWidget _buildSwitchSection(BuildContext context, AppManager appManager, SettingType settingsType, {void Function()? afterChanged}) {
    final SettingData settingData = appManager.settingProvider.getSettingData(settingsType);
    return CardSettingsSwitch(
      label: settingData.getL10nName(context),
      initialValue: settingData.value,
      onChanged: (val) {
        setState(() {
          settingData.value = val;
          appManager.databaseProvider.insertSettings(settingsType, settingData);
          if (afterChanged != null) afterChanged();
        });
      }
    );
  }

  CardSettingsWidget _buildListPickerSection(BuildContext context, AppManager appManager, SettingType settingsType, List<String> values) {
    final SettingData settingData = appManager.settingProvider.getSettingData(settingsType);
    return CardSettingsListPicker(
      label: settingData.getL10nName(context),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: values,
      onChanged: (val) {
        setState(() {
          settingData.value = val;
          appManager.databaseProvider.insertSettings(settingsType, settingData);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppManager appManager = AppManager.byContext(context);
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
              children: <CardSettingsWidget>[
                this._buildInstruction(context, appManager, SettingType.USER_NAME),
                this._buildStringSection(context, appManager, SettingType.USER_NAME, false, (val) {
                  if ((!RegExp("^[a-zA-Z0-9-._]{3,20}\$").hasMatch(val!)) && val != "")
                    return "Only alphabets and numbers are allowed.";
                  else return null;
                }),

                this._buildInstruction(context, appManager, SettingType.USER_PASSWORD),
                this._buildPasswordSection(context, appManager, SettingType.USER_PASSWORD, (val) {
                  if (val!.length != 0 && val.length < 5)
                    return "Only more than 4 characters are allowed.";
                  else return null;
                }),
              ],
            ),
            CardSettingsSection(
              header: this._buildHeader(context, S.of(context).pageSettings_section_network),
              children: <CardSettingsWidget>[
                this._buildInstruction(context, appManager, SettingType.NETWORK_TYPE),
                this._buildListPickerSection(context, appManager, SettingType.NETWORK_TYPE,
                    NetworkManager.getAvailableInterfaceList().map((val) => val.toString()).toList()),

                this._buildInstruction(context, appManager, SettingType.AUTO_CONNECTION),
                this._buildSwitchSection(context, appManager, SettingType.AUTO_CONNECTION),

                this._buildInstruction(context, appManager, SettingType.NETWORK_TIMEOUT),
                this._buildIntSection(context, appManager, SettingType.NETWORK_TIMEOUT, "ms"),
              ],
            ),
            CardSettingsSection(
              header: this._buildHeader(context, S.of(context).pageSettings_section_UIOption),
              children: <CardSettingsWidget>[
                this._buildInstruction(context, appManager, SettingType.ENFORCE_DARK_THEME),
                this._buildSwitchSection(context, appManager, SettingType.ENFORCE_DARK_THEME, afterChanged: () =>
                    Provider.of<AppManager>(context, listen: false).switchTheme()),

                this._buildInstruction(context, appManager, SettingType.HIDE_TOP_BAR),
                this._buildSwitchSection(context, appManager, SettingType.HIDE_TOP_BAR),

                this._buildInstruction(context, appManager, SettingType.HIDE_HOME_KEY),
                this._buildSwitchSection(context, appManager, SettingType.HIDE_HOME_KEY),

                this._buildInstruction(context, appManager, SettingType.USE_VIBRATION),
                this._buildSwitchSection(context, appManager, SettingType.USE_VIBRATION),

                this._buildInstruction(context, appManager, SettingType.USE_WAKE_LOCK),
                this._buildSwitchSection(context, appManager, SettingType.USE_WAKE_LOCK),

                this._buildInstruction(context, appManager, SettingType.USE_BACKGROUND_TITLE),
                this._buildSwitchSection(context, appManager, SettingType.USE_BACKGROUND_TITLE),
              ],
            ),
          ],
        ),
      ),
    );
  }

}