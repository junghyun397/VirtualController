import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:flutter/material.dart';

const String PAGE_LAYOUT_LIST_ROUTE = "/layout";

class PageLayoutList extends StatefulWidget {
  PageLayoutList({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageLayoutListState();
}

class _PageLayoutListState extends DynamicDirectionState<PageLayoutList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Layout"), // TODO: i8n needed
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context),
        )
      ),
      body: Text(
        "layout info here".toUpperCase()
      ),
    );
  }

}