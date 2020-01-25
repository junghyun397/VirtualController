
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/page/panel/builder/page_panel_builder_controller.dart';
import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PagePanelBuilder extends StatefulWidget {
  PagePanelBuilder({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PagePanelBuilderState();
}

class _PagePanelBuilderState extends FixedDirectionWithUIState<PagePanelBuilder> {

  Widget _buildSelectorAreaPanel(BuildContext context) {
    return Container(

    );
  }

  Widget _buildComponentPanel(BuildContext context) {
    return Container(

    );
  }

  // ignore: missing_return
  FormField _buildComponentSettingSection(BuildContext context, ComponentSettingData componentSettingData) {
    switch (componentSettingData.type.toString()) {
      case "bool":
        return CardSettingsSwitch(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].displaySettingName,
          initialValue: componentSettingData.value,
        );
      case "int":
        return CardSettingsInt(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].displaySettingName,
          initialValue: componentSettingData.value,
        );
      case "double":
        return CardSettingsDouble(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].displaySettingName,
          initialValue: componentSettingData.value,
        );
      case "List<double>":
        return CardSettingsText(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].displaySettingName,
          initialValue: componentSettingData.value,
        );
      case "String":
        return CardSettingsText(
          label: COMPONENT_SETTING_DEFINITION[componentSettingData.settingType].displaySettingName,
          initialValue: componentSettingData.value,
        );
    }
  }

  Future<void> _showSetupComponentDialog(BuildContext context, ComponentSetting componentSetting) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Form(
              child: CardSettings.sectioned(
                shrinkWrap: true,
                showMaterialonIOS: true,
                children: <CardSettingsSection>[
                  CardSettingsSection(
                    children: componentSetting.settings.entries.map((e) => _buildComponentSettingSection(context, e.value)).toList(),
                  ),
                  CardSettingsSection(
                    header: CardSettingsHeader(
                      label: "Action",
                    ),
                    children: [
                      CardSettingsButton(
                        label: "OK",
                        backgroundColor: Colors.green,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PagePanelBuilderController controller = PagePanelBuilderController(ModalRoute.of(context).settings.arguments);
    return ChangeNotifierProvider<PagePanelBuilderController>(
      create: (_) => controller,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
          ],
        ),
        appBar: AppBar(
          title: Text(controller.panelSetting.name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: controller.copyPanelToClipboard,
              tooltip: "Export panel",
            ),
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () => controller.savePanel(),
              tooltip: "Save panel",
            ),
          ],
        ),
      ),
    );
  }

}