import 'package:VirtualFlightThrottle/network/network_agent.dart';
import 'package:VirtualFlightThrottle/network/network_manager.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Network"), // TODO: i8n needed
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context),
        )
      ),
      body: SafeArea(
        child: FlatButton(
          onPressed: () => GlobalNetworkManager().networkManager.sendData(new NetworkData(0, true)),
          child: Text("CLICK"),
        ),
      ),
    );
  }

}