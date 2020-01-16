import 'package:VirtualFlightThrottle/network/network_app_manager.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/page/network/page_network_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageNetwork extends StatefulWidget {
  PageNetwork({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageNetworkState();
}

class _PageNetworkState extends DynamicDirectionState<PageNetwork> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildFinding(BuildContext context) {
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
            child: Text("Finding target device..."),
          )
        ],
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
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
                  "PC side device not found.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Please check if " +
                          AppNetworkManager().val.toString() +
                          " is turned on or PC side device is running.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: Provider
                      .of<PageNetworkController>(context)
                      .refreshDeviceList,
                  child: Text(
                    "REFRESH",
                    style: TextStyle(
                      color: Colors.blue,
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

  Widget _buildFound(BuildContext context, List<String> deviceList) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: <Widget>[
              Text(
                "Found ${deviceList.length} PC-side devices.",
              ),
              Spacer(),
              FlatButton(
                onPressed: Provider
                    .of<PageNetworkController>(context)
                    .refreshDeviceList,
                child: Text(
                  "REFRESH",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: deviceList.map((val) =>
              ListTile(
                leading: Icon(Icons.videogame_asset),
                title: Text(val),
                subtitle: Text("Tap to connect with this device"),
                trailing: Text(
                  "ACTIVE",
                  style: TextStyle(color: Colors.green),
                ),
                onTap: () =>
                    Provider.of<PageNetworkController>(context, listen: false)
                        .connectDevice(val, () {
                      this._scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Connection with the server $val failed."),
                        action: SnackBarAction(
                            label: "REFRESH",
                            textColor: Colors.green,
                            onPressed: () {
                              this._scaffoldKey.currentState
                                  .hideCurrentSnackBar();
                              Provider.of<PageNetworkController>(
                                  context, listen: false).refreshDeviceList();
                            }
                        ),
                      ));
                    }),
              ),).toList(),
        ),
      ],
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
                FlatButton(
                  onPressed: Provider
                      .of<PageNetworkController>(context)
                      .disconnectCurrentDevice,
                  child: Text(
                    "DISCONNECT",
                    style: TextStyle(
                      color: Colors.blue,
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageNetworkController>(
      create: (_) => PageNetworkController(),
      child: Scaffold(
        key: this._scaffoldKey,
        appBar: AppBar(
          title: Text("Network"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Consumer<PageNetworkController>(
            builder: (BuildContext context, PageNetworkController value,
                Widget child) {
              switch (value.networkConnectionState) {
                case NetworkConnectionState.FINDING:
                  return this._buildFinding(context);
                case NetworkConnectionState.NOTFOUND:
                  return this._buildNotFound(context);
                case NetworkConnectionState.FOUND:
                  return this._buildFound(context, value.deviceList);
                case NetworkConnectionState.CONNECTED:
                  return this._buildConnected(context);
                default:
                  return this._buildFinding(context);
              }
            },
          ),
        ),
      ),
    );
  }
}