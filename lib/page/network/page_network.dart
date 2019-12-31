import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:flutter/material.dart';

class PageNetwork extends StatefulWidget {
  PageNetwork({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageNetworkState();

}

class _PageNetworkState extends DynamicDirectionState<PageNetwork> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
          "network settings here".toUpperCase()
      ),
    );
  }

}