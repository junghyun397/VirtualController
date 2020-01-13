import 'dart:async';

import 'package:VirtualFlightThrottle/network/network_app_manager.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PageNetwork extends StatefulWidget {
  PageNetwork({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageNetworkState();
}

enum _ConnectionState {
  FINDING,
  NOTFOUND,
  FOUND,
  CONNECTED,
}

class _ConnectionEvent {
  _ConnectionState state;

  List<String> body;

  _ConnectionEvent(this.state, this.body);
}

class _PageNetworkState extends DynamicDirectionState<PageNetwork> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: close_sinks
  final StreamController<_ConnectionEvent> _connectionStateController = StreamController<_ConnectionEvent>();

  Future<void> _refreshTargetList() async {
    // ignore: unrelated_type_equality_checks
    AppNetworkManager().val.findAliveTargetList().then((val) {
      this._connectionStateController.add(_ConnectionEvent(
          (val.isEmpty ? _ConnectionState.NOTFOUND : _ConnectionState.FOUND), val));
    });
    this._connectionStateController.add(_ConnectionEvent(_ConnectionState.FINDING, null));
  }
  
  void _tryConnectToTarget(String target) {
    AppNetworkManager().val.connectToTarget(target, () {
      this._scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("The connection with the server $target failed."),
        action: SnackBarAction(label: "RETRY", onPressed: () {
          this._scaffoldKey.currentState.hideCurrentSnackBar();
          this._tryConnectToTarget(target);
        }),
      ));
    }).then((val) {
      this._connectionStateController.add(_ConnectionEvent(_ConnectionState.CONNECTED, null));
    });
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
            child: Text("finding target device..."),
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
                  "Target device not found.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Please check if " + AppNetworkManager().val.toString() + " is turned on or if the PC side device is running.",
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

  Widget _buildTargetTile(BuildContext context, String target) {
    return ListTile(
      leading: Icon(
        Icons.videogame_asset
      ),
      title: Text(target),
      subtitle: Text("Tap to connect with this device"),
      trailing: Text("ACTIVE", style: TextStyle(color: Colors.green),),
      onTap: () => this._tryConnectToTarget(target),
    );
  }

  Widget _buildTargetList(BuildContext context, List<String> deviceList) {
    return ListView(
      children: deviceList.map((val) => this._buildTargetTile(context, val)).toList(),
    );
  }

  Widget _buildConnected(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: <Widget>[
                Text(
                  "Conntcted with device ${AppNetworkManager().val.targetNetworkAgent.address}",
                  style: TextStyle(fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: RichText(
                    text: TextSpan(
                      text: "DISCONNECT",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          AppNetworkManager().val.disconnectCurrentTarget();
                          this._refreshTargetList();
                        },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    if (AppNetworkManager().val.isConnected)
      this._connectionStateController.add(_ConnectionEvent(_ConnectionState.CONNECTED, null));
    else this._refreshTargetList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
      appBar: AppBar(
        title: Text("Network"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: this._refreshTargetList,
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: this._connectionStateController.stream,
          builder: (BuildContext context, AsyncSnapshot<_ConnectionEvent> snapshot) {
            if (!snapshot.hasData) return Container();
            switch (snapshot.data.state) {
              case _ConnectionState.FINDING:
                return this._buildInProcessing(context);
              case _ConnectionState.NOTFOUND:
                return this._buildTargetNotFound(context);
              case _ConnectionState.FOUND:
                return this._buildTargetList(context, snapshot.data.body);
              case _ConnectionState.CONNECTED:
                return this._buildConnected(context);
              default:
                return this._buildInProcessing(context);
            }
          },
        ),
      ),
    );
  }
}