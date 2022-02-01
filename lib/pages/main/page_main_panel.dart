import 'dart:async';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:vfcs/app_manager.dart';
import 'package:vfcs/generated/l10n.dart';
import 'package:vfcs/network/network_interface.dart';
import 'package:vfcs/pages/orientation_page.dart';
import 'package:vfcs/panel/panel.dart';
import 'package:vfcs/panel/panel_data.dart';
import 'package:vfcs/panel/panel_theme.dart';
import 'package:vfcs/panel/panel_utility.dart';
import 'package:vfcs/routes.dart';
import 'package:vfcs/utility/utility_system.dart';
import 'package:flutter/material.dart';

class PageMainPanel extends StatefulWidget {

  @override
  _PageMainPanelState createState() => _PageMainPanelState();

}

class _PageMainPanelState extends FixedOrientationPage<PageMainPanel> {

  late final StreamSubscription _networkConditionSubscription;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => this._networkConditionSubscription = AppManager.byContext(this.context)
        .networkManager.networkConditionStream.stream.listen((condition) {
          if (condition == NetworkCondition.CONNECTED) ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          else this._showNetworkConditionBanner(context);
        })).ignore();
  }

  void _showNetworkConditionBanner(BuildContext context) =>
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          leading: Icon(Icons.error_outline),
          content: Text(S.of(context).pageMainPanel_warning_deviceServerNotFound),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pushNamed(context, Routes.PAGE_NETWORK),
              child: Text(S.of(context).pageMainPanel_warning_goToNetworkSetting),
            ),
          ],
        ),
      );

  SpeedDial _buildFloatingActionButton(BuildContext context) =>
      SpeedDial(
        curve: Curves.bounceIn,

        overlayColor: Colors.black,
        overlayOpacity: 0.4,

        backgroundColor: PanelTheme.of(context).fabBackgroundColor,
        foregroundColor: PanelTheme.of(context).fabForegroundColor,

        elevation: 0,
        useRotationAnimation: false,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
        ),
        buttonSize: const Size(16, 2),

        children: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.dashboard),
            label: S.of(context).pageMainPanel_FAB_panels,
            onTap: () => Navigator.pushNamed(context, Routes.PAGE_PANEL_LIST),
          ),
          SpeedDialChild(
            child: const Icon(Icons.cast),
            label: S.of(context).pageMainPanel_FAB_network,
            onTap: () => Navigator.pushNamed(context, Routes.PAGE_NETWORK),
          ),
          SpeedDialChild(
            child: const Icon(Icons.settings),
            label: S.of(context).pageMainPanel_FAB_settings,
            onTap: () => Navigator.pushNamed(context, Routes.PAGE_SETTING),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    SystemUtility.physicalSize = MediaQuery.of(context).size;
    final AppManager appManager = AppManager.byContext(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 2,
            child: this._buildFloatingActionButton(context),
          ),
          StreamBuilder<PanelData>(
            stream: appManager.panelManager.switchMainPanelStream.stream,
            initialData: appManager.panelManager.getMainPanel(),
            builder: (context, panelData) {
              final double blockSize = PanelUtility.getBlockSize(panelData.data!, SystemUtility.physicalSize);
              this.orientation = PanelUtility.findPossibleOrientation(panelData.data!, SystemUtility.physicalSize)!;
              return SizedBox(
                  width: SystemUtility.physicalSize.width,
                  height: SystemUtility.physicalSize.height,
                  child: Panel.withAppManager(
                    appManager: appManager,
                    blockSize: blockSize,
                    panelData: panelData.data!,
                  )
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    this._networkConditionSubscription.cancel();
    super.dispose();
  }

}