import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/generated/l10n.dart';
import 'package:VirtualFlightThrottle/network/network_manager.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/panel/panel.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:VirtualFlightThrottle/routes.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:VirtualFlightThrottle/utility/utility_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PageMainPanel extends StatefulWidget {
  PageMainPanel({Key key}): super(key: key);

  @override
  _PageMainPanelState createState() => new _PageMainPanelState();
}

class _PageMainPanelState extends FixedDirectionState<PageMainPanel> {

  Widget _mainPanelCache;

  Widget _buildMainPanel(BuildContext context, BoxConstraints constraints) {
    if (PanelManager().needMainPanelUpdate && constraints.maxHeight == SystemUtility.physicalSize.height) {
      PanelManager().needMainPanelUpdate = false;
      this._mainPanelCache = null;
    }

    if (this._mainPanelCache == null) {
      PanelSetting panelSetting = PanelManager().getMainPanel();
      Size blockSize = PanelUtility.getBlockSize(panelSetting, SystemUtility.physicalSize);
      this._mainPanelCache = SizedBox(
        width: SystemUtility.physicalSize.width,
        height: SystemUtility.physicalSize.height,
        child: Panel(
          blockWidth: blockSize.width,
          blockHeight: blockSize.height,
          panelSetting: panelSetting,
        ),
      );
    }

    return this._mainPanelCache;
  }

  Widget _buildBackgroundText(BuildContext context) {
    if (SettingManager().settingsMap[SettingsType.USE_BACKGROUND_TITLE].value)
      return Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            PanelManager().getMainPanel().name,
            style: TextStyle(
              fontSize: 1000,
              fontWeight: FontWeight.bold,
              color: Colors.black26,
            ),
          ),
        ),
      );
    else return Container();
  }

  Widget _buildTargetDeviceNotFoundAlert(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        height: 30,
        decoration: BoxDecoration(
          color: Theme.of(context).errorColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: const Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            Text(
              S.of(context).pageMainPanel_warning_deviceServerNotFound,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Spacer(),
            FlatButton(
              onPressed: () => Navigator.pushNamed(context, Routes.PAGE_NETWORK),
              child: Text(
                S.of(context).pageMainPanel_warning_goToNetworkSetting,
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
    SystemUtility.physicalSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        child: Stack(
          children: <Widget>[
            LayoutBuilder(builder: (context, _) => this._buildBackgroundText(context)),
            LayoutBuilder(builder: (context, constraints) => this._buildMainPanel(context, constraints)),
            StreamBuilder<bool>(
                stream: NetworkManager().val.networkStateStreamController.stream,
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
            label: S.of(context).pageMainPanel_FAB_panels,
            labelStyle: const TextStyle(
              color: Colors.black54,
            ),
            onTap: () => Navigator.pushNamed(context, Routes.PAGE_PANEL_LIST),
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.cast,
              color: Colors.black87,
            ),
            backgroundColor: Colors.white,
            label: S.of(context).pageMainPanel_FAB_network,
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
            label: S.of(context).pageMainPanel_FAB_settings,
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