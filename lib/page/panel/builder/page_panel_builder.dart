import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/page/panel/builder/page_panel_builder_controller.dart';
import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PagePanelBuilder extends StatefulWidget {
  PagePanelBuilder({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PagePanelBuilderState();
}

class _PagePanelBuilderState extends FixedDirectionWithUIState<PagePanelBuilder> {
  
  Widget _buildComponentSelectorArea(BuildContext context) {
    return Consumer<PagePanelBuilderController>(
      builder: (context, controller, __) {
        Size size = MediaQuery.of(context).size;
        return Expanded(
          child: Container(
            child: Stack(
              children: <Widget>[

              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildComponentListArea(BuildContext context) {
    List<MapEntry<ComponentType, ComponentDefinition>> definitionList = COMPONENT_DEFINITION.entries.toList();
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5.0,
            ),
          ]),
      width: 180,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Components", style: TextStyle(fontSize: 15, color: Colors.white70)),
          ),
          Consumer<PagePanelBuilderController>(
            builder: (context, controller, __) {
              return Expanded(
                child: ListView.builder(
                  itemCount: COMPONENT_DEFINITION.length,
                  itemBuilder: (BuildContext context, int index) {
                    MapEntry<ComponentType, ComponentDefinition> definition = definitionList[index];
                    return ListTile(
                      title: Text(
                        definition.value.displayComponentName,
                        style: TextStyle(color: controller.isSelectionMode ? Colors.white10 : Colors.white),
                      ),
                      subtitle: Text(
                        definition.value.description,
                        style: TextStyle(color: controller.isSelectionMode ? Colors.white10 : Colors.white60),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        color: controller.isSelectionMode ? Colors.white10 : Colors.white,
                        onPressed: () => controller.selectComponent(definition.key),
                      ),
                      enabled: !controller.isSelectionMode,
                    );
                  },
                ),
              );
            }
          ),
        ],
      ),
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
        body: Row(
          children: <Widget>[
            this._buildComponentSelectorArea(context),
            this._buildComponentListArea(context),
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
              onPressed: controller.copyPanelJsonToClipboard,
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