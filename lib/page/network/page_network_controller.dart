import 'dart:async';

import 'package:VirtualFlightThrottle/network/network_manager.dart';
import 'package:flutter/widgets.dart';

enum NetworkConnectionState {
  DISCOVERING,
  NOTFOUND,
  FOUND,
  CONNECTED,
}

class PageNetworkController with ChangeNotifier {

  bool _disposed = false;

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
    if (NetworkManager().val.isConnected) {
      this.networkConnectionState = NetworkConnectionState.CONNECTED;
    } else this.refreshDeviceList();

    this._networkStateStreamSubscription = NetworkManager().val.networkStateStreamController.stream.listen((val) {
      if (val) this.networkConnectionState = NetworkConnectionState.CONNECTED;
      else this.refreshDeviceList();
    });
  }

  void refreshDeviceList() {
    NetworkManager().val.findAliveTargetList().then((val) {
      if (this.networkConnectionState != NetworkConnectionState.DISCOVERING || this._disposed) return;

      if (val.isEmpty) this.networkConnectionState = NetworkConnectionState.NOTFOUND;
      else {
        this.deviceList = val;
        this.networkConnectionState = NetworkConnectionState.FOUND;
      }
    });
    this.networkConnectionState = NetworkConnectionState.DISCOVERING;
  }

  void connectDevice(String target, Function onFail) {
    NetworkManager().val.connectToTarget(target, onFail).then((_) => this.networkConnectionState = NetworkConnectionState.CONNECTED);
  }

  void disconnectCurrentDevice() {
    NetworkManager().val.disconnectCurrentTarget();
    this.refreshDeviceList();
  }

  @override
  void dispose() {
    this._disposed = true;
    this._networkStateStreamSubscription.cancel();
    super.dispose();
  }
}
