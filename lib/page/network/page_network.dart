import 'package:VirtualFlightThrottle/generated/l10n.dart';
import 'package:VirtualFlightThrottle/network/network_manager.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:VirtualFlightThrottle/page/network/page_network_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(S.of(context).pageNetwork_state_findingDeviceServer),
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
                  S.of(context).pageNetwork_state_notFound,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(S.of(context).pageNetwork_state_notFound_description(AppNetworkManager().val.getInterfaceName()),
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
                    S.of(context).pageNetwork_refresh,
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
              Text(S.of(context).pageNetwork_state_found(deviceList.length)),
              Spacer(),
              FlatButton(
                onPressed: Provider
                    .of<PageNetworkController>(context)
                    .refreshDeviceList,
                child: Text(
                  S.of(context).pageNetwork_refresh,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: ListView(
            children: deviceList.map((val) =>
                ListTile(
                  leading: Icon(AppNetworkManager().val.getInterfaceIcon()),
                  title: Text(val),
                  subtitle: Text(S.of(context).pageNetwork_state_found_tapToConnection),
                  trailing: Text(
                    S.of(context).pageNetwork_active,
                    style: TextStyle(color: Colors.green),
                  ),
                  onTap: () =>
                      Provider.of<PageNetworkController>(context, listen: false).connectDevice(val, () {
                        this._scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(S.of(context).pageNetwork_state_found_connectionFailed(val)),
                          action: SnackBarAction(
                              label: S.of(context).pageNetwork_refresh,
                              textColor: Colors.green,
                              onPressed: () {
                                this._scaffoldKey.currentState.hideCurrentSnackBar();
                                Provider.of<PageNetworkController>(context, listen: false).refreshDeviceList();
                              }
                          ),
                        ));
                      }),
                ),).toList(),
          ),
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
                  S.of(context).pageNetwork_state_found_connectionSucceed(AppNetworkManager().val.targetNetworkAgent.address),
                  style: TextStyle(fontSize: 16),
                ),
                FlatButton(
                  onPressed: Provider.of<PageNetworkController>(context).disconnectCurrentDevice,
                  child: Text(
                    S.of(context).pageNetwork_disconnect,
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
          title: Text(S.of(context).pageNetwork_title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () => launch(S.of(context).helpWikiLink_network),
              tooltip: "Help",
            ),
          ],
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