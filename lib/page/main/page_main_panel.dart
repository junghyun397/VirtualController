import 'package:VirtualFlightThrottle/network/network_app_manager.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/panel/panel.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
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

  Widget _mainPanelCache;

  Widget _buildMainPanel(BuildContext context) {
    if (AppPanelManager().needMainPanelUpdate) {
      AppPanelManager().needMainPanelUpdate = false;
      this._mainPanelCache = null;
    }

    if (this._mainPanelCache == null) {
      PanelSetting panelSetting = AppPanelManager().panelList[0];
      Size blockSize = PanelUtility.getBlockSize(panelSetting, MediaQuery.of(context).size);
      return this._mainPanelCache = Container(
        child: Panel(
            blockWidth: blockSize.width,
            blockHeight: blockSize.height,
            panelSetting: panelSetting,
            panelController: PanelController(),
        ),
      );
    }

    return this._mainPanelCache;
  }

  Widget _buildTargetDeviceNotFoundAlert(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        height: 30,
        decoration: BoxDecoration(
          color: Theme.of(context).errorColor,
          boxShadow: [
            new BoxShadow(
              color: Colors.black,
              offset: new Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 1,
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
                size: 20,
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
                  color: Colors.blue,
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
            this._buildMainPanel(context),
            StreamBuilder<bool>(
                stream: AppNetworkManager().val.networkStateStreamController.stream,
                initialData: false,
                builder: (context, snapshot) {
                  if (!snapshot.data) return this._buildTargetDeviceNotFoundAlert(context);
                  return Container();
                }
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

        backgroundColor: Colors.white,
        foregroundColor: Colors.black,

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