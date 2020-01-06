import 'package:VirtualFlightThrottle/network/network_app_manager.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

const String PAGE_NETWORK_ROUTE = "/network";

class PageNetwork extends StatefulWidget {
  PageNetwork({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageNetworkState();
}

class _PageNetworkState extends DynamicDirectionState<PageNetwork> {

  final AsyncCache<List<String>> _aliveTargetCache = AsyncCache<List<String>>(const Duration(hours: 1));

  Future<List<String>> get _aliveTargetList => this._aliveTargetCache.fetch(() {
    return AppNetworkManager().val.findAliveTargetList();
  });

  void _refetchAliveTargetList() {
    this.setState(() {this._aliveTargetCache.invalidate();});
  }

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
                      "Please check if Wi-Fi is turned on and if the PC side client is running.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
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
        title: Text("Network"), // TODO: i8n needed
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refetchAliveTargetList,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _aliveTargetList,
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