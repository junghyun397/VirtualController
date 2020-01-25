import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/page/panel/list/page_panel_list_controller.dart';
import 'package:VirtualFlightThrottle/page/panel/list/widget/panel_builder_dialog.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:VirtualFlightThrottle/routes.dart';
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
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text("CENCLE"),
              ),
              FlatButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text("REMOVE"),
              ),
            ],
        );
      }
    ); 
  }

  Future<PanelSetting> _showBuildPanelDialog(BuildContext context, bool jsonMode) async {
    return await showDialog<PanelSetting>(
      context: context,
      builder: (BuildContext dialogContext) => PanelBuilderDialog(jsonMode: jsonMode),
    );
  }

  Widget _buildPanelListTile(BuildContext context, PanelSetting panelSetting, int index) {
    return ListTile(
      leading: index == 0 ? Icon(Icons.check) : Icon(Icons.layers),
      title: Text(panelSetting.name),
      subtitle: Text("${panelSetting.width}x${panelSetting.height} panel with ${panelSetting.components.length} components\n"
          "Last activation at ${DateTime.fromMillisecondsSinceEpoch(panelSetting.date).toIso8601String().substring(0, 19)}."),
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
      onTap: () => Provider.of<PagePanelListController>(context, listen: false).setAsMainPanel(panelSetting),
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () => this._showBuildPanelDialog(context, true).then((val) {
                if (val == null) return;
                pagePanelListController.insertPanel(val);
              }),
              tooltip: "Import panel",
            ),
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () => null,
              tooltip: "Help",
            ),
          ],
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
          onPressed: () => this._showBuildPanelDialog(context, false).then((val) {
            if (val == null) return;
            pagePanelListController.insertPanel(val);
            Navigator.pushNamed(context, Routes.PAGE_PANEL_BUILDER, arguments: val);
          }),
        ),
      ),
    );
  }

}