import 'dart:async';
import 'dart:io';

import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/data/sqlite3_manager.dart';
import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:VirtualFlightThrottle/network/interface/network_wifi.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class NetworkManager {
  
  final SettingManager settingManager;

  bool isConnected = false;

  // ignore: close_sinks
  StreamController<bool> networkStateStreamController = StreamController<bool>.broadcast();

  NetworkAgent targetNetworkAgent;

  List<NetworkData> _buffer = [];

  NetworkManager(this.settingManager);

  factory NetworkManager.fromNetworkType(NetworkType networkType, SettingManager settingManager) {
    switch (networkType) {
      case NetworkType.WEB_SOCKET:
        return WifiNetworkManager(settingManager);
      default:
        return WifiNetworkManager(settingManager);
    }
  }

  static List<NetworkType> getAvailableInterfaceList() {
    if (kIsWeb)
      return [
        NetworkType.WEB_SOCKET,
      ];
    else if (Platform.isAndroid)
      return [
        NetworkType.WEB_SOCKET,
        NetworkType.BLUETOOTH,
        NetworkType.USB_SERIAL,
      ];
    else if (Platform.isIOS)
      return [
        NetworkType.WEB_SOCKET,
        NetworkType.BLUETOOTH,
      ];
    else
      return [
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

  Future<bool> checkInterfaceAlive();

  Future<List<String>> findAliveTargetList();

  Future<void> connectToTarget(String deviceAddress, Function() onSessionLost);

  void setConnectedState() {
    this.isConnected = true;
    this.networkStateStreamController.add(true);
    if (this.settingManager.settingsMap[SettingsType.AUTO_CONNECTION].value)
      SQLite3Manager().insertRegisteredDevices(this.targetNetworkAgent.address);
  }

  void setDisconnectedState() {
    this.isConnected = false;
    this.networkStateStreamController.add(false);
  }

  void disconnectCurrentTarget() {
    this.setDisconnectedState();
    this.targetNetworkAgent.killSession();
    this.isConnected = false;
  }

  void sendData(NetworkData networkData) {
    if (!this.isConnected)
      this._buffer.add(networkData);
    else if (this._buffer.isNotEmpty) {
      this._buffer.add(networkData);
      this._buffer.forEach((val) =>
          this.targetNetworkAgent.sendData(networkData));
      this._buffer.clear();
    }
    else
      this.targetNetworkAgent.sendData(networkData);
  }

  void startNotifyNetworkStateToast() =>
    this.networkStateStreamController.stream.listen((val) {
      if (val) SystemUtility.showToast(message: "Connected with device.", backgroundColor: Colors.green);
      else SystemUtility.showToast(message: "Disconnected with device.", backgroundColor: Colors.red);
    });

  Future<void> tryAutoReconnection() async {
    if ((!this.isConnected) && this.settingManager.settingsMap[SettingsType.AUTO_CONNECTION].value) {
      List<String> registered = await SQLite3Manager().getSavedRegisteredDevices();
      await this.findAliveTargetList().then((val) => val.forEach((target) {
        if (registered.contains(target)) this.connectToTarget(target, () => null);
      }));
    }
  }
}