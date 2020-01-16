import 'dart:async';

import 'package:VirtualFlightThrottle/network/network_app_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum NetworkConnectionState {
  FINDING,
  NOTFOUND,
  FOUND,
  CONNECTED,
}

class PageNetworkController with ChangeNotifier {
  NetworkConnectionState _networkConnectionStateCache;

  get networkConnectionState => this._networkConnectionStateCache;

  set networkConnectionState(NetworkConnectionState networkConnectionState) {
    this._networkConnectionStateCache = networkConnectionState;
    notifyListeners();
  }

  List<String> deviceList;

  // ignore: cancel_subscriptions
  StreamSubscription<bool> _networkStateStreamSubscription;

  PageNetworkController() {
    if (AppNetworkManager().val.isConnected) {
      this.networkConnectionState = NetworkConnectionState.CONNECTED;
    } else
      this.refreshDeviceList();

    this._networkStateStreamSubscription = AppNetworkManager()
        .val
        .networkStateStreamController
        .stream
        .listen((val) {
      if (val)
        this.networkConnectionState = NetworkConnectionState.CONNECTED;
      else
        this.refreshDeviceList();
    });
  }

  void refreshDeviceList() {
    AppNetworkManager().val.findAliveTargetList().then((val) {
      if (this.networkConnectionState != NetworkConnectionState.FINDING) return;

      if (val.isEmpty)
        this.networkConnectionState = NetworkConnectionState.NOTFOUND;
      else {
        this.deviceList = val;
        this.networkConnectionState = NetworkConnectionState.FOUND;
      }
    });
    this.networkConnectionState = NetworkConnectionState.FINDING;
  }

  void connectDevice(String target, Function onFail) {
    AppNetworkManager().val.connectToTarget(target, () {
      onFail();
    }).then((_) {
      this.networkConnectionState = NetworkConnectionState.CONNECTED;
    });
  }

  void disconnectCurrentDevice() {
    AppNetworkManager().val.disconnectCurrentTarget();
    this.refreshDeviceList();
  }

  @override
  void dispose() {
    this._networkStateStreamSubscription.cancel();
    super.dispose();
  }
}
