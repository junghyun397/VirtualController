import 'dart:async';

import 'package:vfcs/network/network_manager.dart';
import 'package:flutter/widgets.dart';

enum NetworkCondition {
  DISCOVERING,
  NOTFOUND,
  FOUND,
  CONNECTED,
}

class PageNetworkController with ChangeNotifier {

  bool _disposed = false;

  NetworkCondition _networkConnectionStateCache;
  get networkConnectionState => this._networkConnectionStateCache;
  set networkConnectionState(NetworkCondition networkConnectionState) {
    this._networkConnectionStateCache = networkConnectionState;
    notifyListeners();
  }

  final List<String> deviceList;

  // ignore: cancel_subscriptions
  StreamSubscription<bool> _networkStateStreamSubscription;

  PageNetworkController() {
    if (NetworkManager().val.isConnected) {
      this.networkConnectionState = NetworkCondition.CONNECTED;
    } else this.refreshDeviceList();

    this._networkStateStreamSubscription = NetworkManager().val.networkConditionStream.stream.listen((val) {
      if (val) this.networkConnectionState = NetworkCondition.CONNECTED;
      else this.refreshDeviceList();
    });
  }

  void refreshDeviceList() {
    NetworkManager().val.findAvailableServerList().then((val) {
      if (this.networkConnectionState != NetworkCondition.DISCOVERING || this._disposed) return;

      if (val.isEmpty) this.networkConnectionState = NetworkCondition.NOTFOUND;
      else {
        this.deviceList = val;
        this.networkConnectionState = NetworkCondition.FOUND;
      }
    });
    this.networkConnectionState = NetworkCondition.DISCOVERING;
  }

  void connectDevice(String target, Function onFail) {
    NetworkManager().val.connectToTarget(target, onFail).then((_) => this.networkConnectionState = NetworkCondition.CONNECTED);
  }

  void disconnectCurrentDevice() {
    NetworkManager().val.disconnectCurrentServer();
    this.refreshDeviceList();
  }

  @override
  void dispose() {
    this._disposed = true;
    this._networkStateStreamSubscription.cancel();
    super.dispose();
  }
}
