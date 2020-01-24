import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:flutter/material.dart';

class PagePanelStore extends StatefulWidget {
  PagePanelStore({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PagePanelStoreState();
}

class _PagePanelStoreState extends DynamicDirectionState<PagePanelStore> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
          "layout store here".toUpperCase()
      ),
    );
  }

}