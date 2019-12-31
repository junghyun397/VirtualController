import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:flutter/material.dart';

class PageSettings extends StatefulWidget {
  PageSettings({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageSettingsState();

}

class _PageSettingsState extends DynamicDirectionState<PageSettings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Settigs"), // TODO: i8n needed
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context),
        )
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("O1" * 256),
            Text("O2" * 256),
          ],
        ),
      )
    );
  }

}