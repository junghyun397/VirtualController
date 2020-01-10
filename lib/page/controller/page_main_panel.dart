import 'package:VirtualFlightThrottle/panel/component/builder/component_builder.dart';
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
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Container(
        child: Center(
          child: Text(
            "main panel here".toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        marginBottom: 30,
        marginRight: 30,

        shape: CircleBorder(),
        animatedIcon: AnimatedIcons.menu_close,
        curve: Curves.bounceIn,

        overlayColor: Colors.black,
        overlayOpacity: 0.4,

        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,

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