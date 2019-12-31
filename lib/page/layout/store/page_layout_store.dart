import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:flutter/material.dart';

class PageLayoutStore extends StatefulWidget {
  PageLayoutStore({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageLayoutStoreState();

}

class _PageLayoutStoreState extends DynamicDirectionState<PageLayoutStore> {

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
          "layout store here".toUpperCase()
      ),
    );
  }

}