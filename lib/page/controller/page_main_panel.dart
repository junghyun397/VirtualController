import 'package:VirtualFlightThrottle/component/component_builder.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/routes.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PageMainPanel extends StatefulWidget {
  PageMainPanel({Key key}): super(key: key);

  @override
  _PageMainPanelState createState() => new _PageMainPanelState();

}

class _PageMainPanelState extends RootFixedDirectionState<PageMainPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: SafeArea(
          top: false,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                ComponentBuilder.buildSlider(
                    context: context,
                    name: "ata",
                    range: 1.3,
                    axis: Axis.vertical,
                    unitName: "ata",
                    markDensity: 0.4,
                  detentPoints: [0.1, 0.5, 1, 1.2]
                ),
                ComponentBuilder.buildSlider(
                    context: context,
                    name: "rpm",
                    range: 2600,
                    axis: Axis.vertical,
                    useIntRange: true,
                    unitName: "rpm",
                    markDensity: 0.5,
                markSightCount: 4),
                ComponentBuilder.buildSlider(
                    context: context,
                    name: "prop",
                    range: 30,
                    axis: Axis.vertical,
                    useIntRange: true,
                    unitName: "dig",
                    markDensity: 0.8,
                markSightCount: 9),
                ComponentBuilder.buildSlider(
                    context: context,
                    name: "wtr",
                    range: 80,
                    axis: Axis.vertical,
                    useIntRange: true,
                    unitName: "lit",
                    markDensity: 0.3,
                useMarkSightValue: false),
                ComponentBuilder.buildSlider(
                    context: context,
                    name: "stb",
                    range: 40,
                    axis: Axis.vertical,
                    unitName: "std",
                    markDensity: 0.1,
                markSightCount: 1),
              ],
            ),
          )),
      floatingActionButton: SpeedDial(
        shape: CircleBorder(),
        animatedIcon: AnimatedIcons.menu_close,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onOpen: () => UtilitySystem.enableUIOverlays(true),
        onClose: () => UtilitySystem.enableUIOverlays(false),
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.dashboard,
              color: Colors.black87,
            ),
            backgroundColor: Colors.white,
            label: "Layout",
            labelStyle: const TextStyle(
              color: Colors.black54,
            ),
            onTap: () => Navigator.pushNamed(context, Routes.PAGE_LAYOUT_LIST),
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.cast_connected,
              color: Colors.black87,
            ),
            backgroundColor: Colors.white,
            label: "PC Client",
            labelStyle: const TextStyle(
              color: Colors.black54,
            ),
            onTap: () => Navigator.pushNamed(context, Routes.PAGE_NETWORK),
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.settings,
              color: Colors.black87,
            ),
            backgroundColor: Colors.white,
            label: "Setting",
            labelStyle: const TextStyle(
              color: Colors.black54,
            ),
            onTap: () => Navigator.pushNamed(context, Routes.PAGE_SETTING),
          ),
        ],
      ),
    );
  }
}