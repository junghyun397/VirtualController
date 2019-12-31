import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:flutter/material.dart';

class PageLayoutList extends StatefulWidget {
  PageLayoutList({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageLayoutListState();

}

class _PageLayoutListState extends DynamicDirectionState<PageLayoutList> {

  @override
  void initState() {
    UtilitySystem.enableFixedDirection(false);
    UtilitySystem.enableUIOverlays(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        "layout info here".toUpperCase()
      ),
    );
  }

}