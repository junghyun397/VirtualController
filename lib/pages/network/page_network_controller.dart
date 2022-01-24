import 'dart:async';

import 'package:vfcs/network/network_interface.dart';
import 'package:vfcs/network/network_manager.dart';
import 'package:flutter/widgets.dart';

enum DiscoverCondition {
  DISCOVERING,
  NOTFOUND,
  FOUND,
  CONNECTED,
  DISPOSED;
}

class PageNetworkController with ChangeNotifier {

  final NetworkManager _networkManager;
  
  late DiscoverCondition _discoverCondition;

  final List<String> deviceList = List.empty(growable: true);

  late final StreamSubscription<NetworkCondition> _networkConditionSubscription;

  PageNetworkController(this._networkManager) {
    if (this._networkManager.networkCondition == NetworkCondition.CONNECTED) {
      this._discoverCondition = DiscoverCondition.CONNECTED;
    } else this.refreshServerList();

    this._networkConditionSubscription = this._networkManager.networkConditionStream.stream.listen((condition) {
      if (condition == NetworkCondition.CONNECTED) this._discoverCondition = DiscoverCondition.CONNECTED;
      else this.refreshServerList();
    });
  }

  void refreshServerList() {
    this._networkManager.discoverAvailableServers().then((devices) {
      if (this._discoverCondition != DiscoverCondition.DISCOVERING) return;

      if (devices.isEmpty) this._discoverCondition = DiscoverCondition.NOTFOUND;
      else {
        this.deviceList.addAll(devices);
        this._discoverCondition = DiscoverCondition.FOUND;
      }
    });

    this._discoverCondition = DiscoverCondition.DISCOVERING;
  }

  void connectServerByAddress(String address, {Function()? onSessionLost}) {
    this._networkManager.connectByAddress(address, onSessionLost: onSessionLost)
        .then((_) => this._discoverCondition = DiscoverCondition.CONNECTED);
  }

  void disconnectCurrentServer() {
    this._networkManager.disconnectCurrentServer();
    this.refreshServerList();
  }

  @override
  void dispose() {
    this._discoverCondition = DiscoverCondition.DISPOSED;
    this._networkConditionSubscription.cancel();
    super.dispose();
  }
}
