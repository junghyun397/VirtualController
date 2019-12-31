import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PageMainController extends StatefulWidget {
  PageMainController({Key key}): super(key: key);

  @override
  _PageMainControllerState createState() => new _PageMainControllerState();

}

class _PageMainControllerState extends RootFixedDirectionState<PageMainController> {

  bool _fabVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SizedBox(
          child: Wrap(
            children: <Widget>[
              Text("master controller widget here".toUpperCase()),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        shape: CircleBorder(),
        animatedIcon: AnimatedIcons.menu_close,
        curve: Curves.bounceIn,

        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,

        visible: this._fabVisible,
        onOpen: () => UtilitySystem.enableUIOverlays(true),
        onClose: () => UtilitySystem.enableUIOverlays(false),

        children: [
          SpeedDialChild(
            child: Icon(
              Icons.dashboard,
              color: Colors.black87),
            backgroundColor: Colors.white,
             label: "Layout", // TODO: i8n needed
            onTap: () => Navigator.pushNamed(context, "/layout"),
          ),
          SpeedDialChild(
            child: Icon(
              Icons.cast_connected,
              color: Colors.black87),
            backgroundColor: Colors.white,
            label: "PC Client", // TODO: i8n needed
            onTap: () => Navigator.pushNamed(context, "/network"),
          ),
          SpeedDialChild(
            child: Icon(
              Icons.settings,
              color: Colors.black87),
            backgroundColor: Colors.white,
            label: "Setting", // TODO: i8n needed
            onTap: () => Navigator.pushNamed(context, "/settings"),
          ),
        ],
      ),
    );
  }

}