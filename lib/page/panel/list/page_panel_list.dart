import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/page/panel/list/page_panel_list_controller.dart';
import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:VirtualFlightThrottle/routes.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PagePanelList extends StatefulWidget {
  PagePanelList({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PagePanelListState();
}

class _PagePanelListState extends DynamicDirectionState<PagePanelList> {

  Future<bool> _showRemoveAlertDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Remove panel"),
          content: Text("Do you want to remove the saved panel?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text("REMOVE"),
              ),
              FlatButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text("CENCLE"),
              ),
            ],
        );
      }
    ); 
  }

  Future<PanelSetting> _showBuildPanelFrame(BuildContext context) async {
    Pair<int, int> maxSize = PanelUtility.getMaxPanelSize(MediaQuery.of(context).size);
    String name = "Unnamed Panel ${DateTime.now().toIso8601String().substring(0, 19)}";
    int width = maxSize.a, height = maxSize.b;
    return await showDialog<PanelSetting>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Form(
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
                        hintText: name,
                        initialValue: "",
                        requiredIndicator: Text("*", style: TextStyle(color: Colors.red)),
                        autovalidate: true,
                        validator: (val) {
                          if (val.length > 35 && val != "") return "max 35 word.";
                          else return null;
                        },
                        onChanged: (val) => name = val,
                      ),
                      CardSettingsInt(
                        label: "Panel width",
                        unitLabel: "blocks",
                        initialValue: maxSize.a,
                        onChanged: (val) => width = val,
                      ),
                      CardSettingsInt(
                        label: "Panel height",
                        unitLabel: "blocks",
                        initialValue: maxSize.b,
                        onChanged: (val) => height = val,
                      ),
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
                        onPressed: () {
                          PanelSetting panelSetting = getBasicPanelSetting(name: name, width: width, height: height);
                          Navigator.pop(context, panelSetting);
                        },
                      ),
                      CardSettingsButton(
                        label: "CENCLE",
                        backgroundColor: Colors.red,
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
    );
  }

  Widget _buildPanelListTile(BuildContext context, PanelSetting panelSetting, int index) {
    return ListTile(
      leading: Icon(Icons.layers),
      title: Text(panelSetting.name),
      subtitle: Text("${panelSetting.width}x${panelSetting.height} panel with ${panelSetting.components.length} components"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.green,
            ),
            onPressed: () => Navigator.pushNamed(context, Routes.PAGE_PANEL_BUILDER, arguments: panelSetting),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            onPressed: () => this._showRemoveAlertDialog(context).then((val) =>
            val != null && val ? Provider.of<PagePanelListController>(context, listen: false).removePanel(panelSetting.name) : null),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PagePanelListController pagePanelListController = PagePanelListController();
    return ChangeNotifierProvider<PagePanelListController>(
      create: (_) => pagePanelListController,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Panels"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context),
          ),
        ),
        body: Container(
          child: Consumer<PagePanelListController>(
            builder: (BuildContext context, _, __) => ListView.builder(
              itemCount: AppPanelManager().panelList.length,
              itemBuilder: (BuildContext context, int index) =>
                  this._buildPanelListTile(context, AppPanelManager().panelList[index], index),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => this._showBuildPanelFrame(context).then((val) {
            if (val == null) return;
            pagePanelListController.insertPanel(val);
            Navigator.pushNamed(context, Routes.PAGE_PANEL_BUILDER, arguments: val);
          }),
        ),
      ),
    );
  }

}