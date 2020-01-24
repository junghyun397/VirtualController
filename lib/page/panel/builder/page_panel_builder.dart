import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';

class PagePanelBuilder extends StatefulWidget {
  PagePanelBuilder({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PagePanelBuilderState();
}

class _PagePanelBuilderState extends FixedDirectionState<PagePanelBuilder> {

  PanelSetting _targetPanelSetting;

  @override
  Widget build(BuildContext context) {
    this._targetPanelSetting = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Text(this._targetPanelSetting.name),
    );
  }

}