import 'package:VirtualFlightThrottle/network/network_app_manager.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:flutter/material.dart';

class PageNetwork extends StatefulWidget {
  PageNetwork({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageNetworkState();
}

class _PageNetworkState extends DynamicDirectionState<PageNetwork> {

  Widget _buildInProcessing(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
            width: 80,
            height: 80,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text("finding target client..."),
          )
        ],
      ),
    );
  }

  Widget _buildTargetNotFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: <Widget>[
                Text(
                  "Target client not found.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Please check if " + AppNetworkManager().val.toString() + " is turned on and if the PC side client is running.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTargetList(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Network"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => null,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: null,
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData && snapshot.data.isEmpty) return this._buildTargetNotFound(context);
            else if (snapshot.hasData && snapshot.data.isNotEmpty) return this._buildTargetList(context);
            else return this._buildInProcessing(context);
          },
        ),
      ),
    );
  }
}