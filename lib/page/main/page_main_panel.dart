import 'package:VirtualFlightThrottle/network/network_app_manager.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PageMainPanel extends StatefulWidget {
  PageMainPanel({Key key}): super(key: key);

  @override
  _PageMainPanelState createState() => new _PageMainPanelState();
}

class _PageMainPanelState extends RootFixedDirectionState<PageMainPanel> {

  Widget _buildTargetClientNotFoundAlert(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        height: 30,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          boxShadow: [
            new BoxShadow(
              color: Colors.black,
              offset: new Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 2,
            )
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
            ),
            Text(
              "Target device not found.",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Spacer(),
            FlatButton(
              onPressed: () => Navigator.pushNamed(context, Routes.PAGE_NETWORK),
              child: Text(
                "Go to network settings",
                style: TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Container(
        child: Stack(
          children: <Widget>[
            StreamBuilder<bool>(
              stream: AppNetworkManager().val.networkStateStreamController.stream,
              initialData: false,
              builder: (context, snapshot) {
                if (!snapshot.data) return this._buildTargetClientNotFoundAlert(context);
                return Container();
              }
            ),
            Center(
              child: Text(
                "main panel here".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
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
              Icons.cast,
              color: Colors.black87,
            ),
            backgroundColor: Colors.white,
            label: "Network",
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