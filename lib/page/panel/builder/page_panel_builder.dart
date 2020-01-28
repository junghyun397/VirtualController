import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/page/panel/builder/page_panel_builder_controller.dart';
import 'package:VirtualFlightThrottle/page/panel/builder/widget/component_builder_dialog.dart';
import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PagePanelBuilder extends StatefulWidget {
  PagePanelBuilder({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PagePanelBuilderState();
}

class _PagePanelBuilderState extends FixedDirectionWithUIState<PagePanelBuilder> {
  
  Future<bool> _showComponentBuilderDialog(BuildContext context, ComponentSetting componentSetting) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => ComponentBuilderDialog(targetComponentSetting: componentSetting),
    );
  }
  
  Widget _buildComponentSelectorAreaInfo(BuildContext context) {
    return Consumer<PagePanelBuilderController>(
      builder: (context, controller, __) {
        return Container(
          margin: EdgeInsets.fromLTRB(6, 5, 5, 5),
          height: 20,
          child: Row(
            children: <Widget>[
              Text(
                controller.isSelectionMode
                  ? "Select an empty space to specify location and size of the component."
                  : "Tap on components to modify components.",
                style: TextStyle(
                  fontSize: 12,
                  color: controller.isSelectionMode ? Colors.red : Theme.of(context).textTheme.body1.color
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComponentSingleArea(BuildContext context, ComponentSetting component, PagePanelBuilderController controller, Size blockSize) {
    return GestureDetector(
      onTap: controller.isSelectionMode ? null : () => this._showComponentBuilderDialog(context, component).then((val) {
        if (val != null && !val) controller.removeComponent(component.name);
        else if (val != null && val) controller.updateComponent(component);
      }),
      child: Container(
        padding: EdgeInsets.all(3),
        width: component.width * blockSize.width,
        height: component.height * blockSize.height,
        child: Container(
          decoration: BoxDecoration(
            color: controller.isSelectionMode ? Colors.red : Colors.indigo,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Container(
            child: Center(
              child: Text(
                component.name,
                style: TextStyle(fontSize: 10, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildComponentSelectAbleArea(BuildContext context, Pair<int, int> position, PagePanelBuilderController controller, Size blockSize) {
    return GestureDetector(
      
    );
  }
  
  Widget _buildComponentSelectorArea(BuildContext context) {
    return Consumer<PagePanelBuilderController>(
      builder: (context, controller, __) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.all(4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                Size blockSize = PanelUtility.getBlockSize(controller.panelSetting, constraints.biggest, topMargin: 0);
                return Stack(
                  children: controller.panelSetting.components.entries.map((component) {
                    return Positioned(
                      left: component.value.x * blockSize.width,
                      bottom: component.value.y * blockSize.height,
                      child: _buildComponentSingleArea(context, component.value, controller, blockSize),
                    );
                }).toList(),
                );
              }
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
            margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
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
        body: Row(
          children: <Widget>[
            Flexible(
              child: Column(
                children: <Widget>[
                  this._buildComponentSelectorAreaInfo(context),
                  this._buildComponentSelectorArea(context),
                ],
              ),
            ),
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
              icon: Icon(Icons.help_outline),
              onPressed: () => controller.savePanel(),
              tooltip: "Help",
            ),
          ],
        ),
      ),
    );
  }

}