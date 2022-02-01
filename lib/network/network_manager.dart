import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/data/database_provider.dart';
import 'package:vfcs/network/impls/network_websocket.dart';
import 'package:vfcs/network/network_agent.dart';
import 'package:vfcs/network/network_interface.dart';
import 'package:vfcs/utility/disposable.dart';
import 'package:vfcs/utility/utility_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class NetworkManager implements Disposable {

  final SettingsProvider settingsProvider;
  final DatabaseProvider _databaseProvider;

  late NetworkAgent networkAgent;

  NetworkCondition _networkCondition = NetworkCondition.DISCONNECTED;
  NetworkCondition get networkCondition => this._networkCondition;
  set networkCondition(NetworkCondition networkCondition) {
    this._networkCondition = networkCondition;
    this.networkConditionStream.add(networkCondition);
  }

  final StreamController<NetworkCondition> networkConditionStream = StreamController<NetworkCondition>.broadcast();

  final Queue<NetworkData> _queue = Queue();

  NetworkManager(this.settingsProvider, this._databaseProvider);

  factory NetworkManager.fromNetworkType(NetworkType networkType, SettingsProvider settingsProvider, DatabaseProvider databaseProvider) {
    switch (networkType) {
      case NetworkType.WEB_SOCKET:
        return WebSocketManager(settingsProvider, databaseProvider);
      default:
        return WebSocketManager(settingsProvider, databaseProvider);
    }
  }

  static List<NetworkType> getAvailableInterfaceList() {
    return [NetworkType.WEB_SOCKET];
    // TODO: implement BLUETOOTH, USB_SERIAL
    // ignore: dead_code
    if (kIsWeb)
      return const <NetworkType>[
        NetworkType.WEB_SOCKET,
      ];
    else if (Platform.isAndroid)
      return const <NetworkType>[
        NetworkType.WEB_SOCKET,
        NetworkType.BLUETOOTH,
        NetworkType.USB_SERIAL,
      ];
    else if (Platform.isIOS)
      return const <NetworkType>[
        NetworkType.WEB_SOCKET,
        NetworkType.BLUETOOTH,
      ];
    else
      return const <NetworkType>[
        NetworkType.WEB_SOCKET,
      ];
  }
  
  static String getInterfaceName(NetworkType networkType) {
    switch (networkType) {
      case NetworkType.WEB_SOCKET:
        return "WiFi";
      case NetworkType.BLUETOOTH:
        return "BlueTooth";
      case NetworkType.USB_SERIAL:
        return "USB Cable";
      default:
        return networkType.toString();
    }
  }

  static IconData getInterfaceIcon(NetworkType networkType) {
    switch (networkType) {
      case NetworkType.WEB_SOCKET:
        return Icons.wifi;
      case NetworkType.BLUETOOTH:
        return Icons.bluetooth;
      case NetworkType.USB_SERIAL:
        return Icons.usb;
      default:
        return Icons.videogame_asset;
    }
  }

  Future<bool> checkInterfaceAvailable();

  Future<List<String>> discoverAvailableServers();

  Future<void> connectByAddress(String deviceAddress, {Function()? onSessionLost});

  void setConnectedCondition() {
    this.networkCondition = NetworkCondition.CONNECTED;
    if (this.settingsProvider.getSettingData(SettingType.AUTO_CONNECTION).value)
      this._databaseProvider.insertRegisteredDevices(this.networkAgent.address);
  }

  void setDisconnectedCondition() =>
    this.networkCondition = NetworkCondition.DISCONNECTED;

  void disconnectCurrentServer() {
    this.setDisconnectedCondition();
    this.networkAgent.killSession();
  }

  void sendPacket(NetworkData networkData) {
    if (this._networkCondition == NetworkCondition.DISCONNECTED) this._queue.add(networkData);
    else if (this._queue.isNotEmpty) {
      this._queue.add(networkData);
      this._queue.forEach((val) => this.networkAgent.sendPacket(networkData));
      this._queue.clear();
    } else this.networkAgent.sendPacket(networkData);
  }

  void startNotifyNetworkConditionToast() =>
    this.networkConditionStream.stream.listen((condition) {
      if (condition == NetworkCondition.CONNECTED) SystemUtility.showToast("Connected with Server.", backgroundColor: Colors.green);
      else SystemUtility.showToast("Disconnected with Server.", backgroundColor: Colors.red);
    });

  Future<void> tryAutoReconnection() async {
    if ((this._networkCondition == NetworkCondition.DISCONNECTED) 
        && this.settingsProvider.getSettingData(SettingType.AUTO_CONNECTION).value) {
      final List<String> registered = DatabaseProvider().getSavedRegisteredDevices();
      await this.discoverAvailableServers().then((servers) => servers.forEach((target) {
        if (registered.contains(target)) this.connectByAddress(target, onSessionLost: () => null);
      }));
    }
  }
  
  @override
  void dispose() => this.networkConditionStream.close();
  
}