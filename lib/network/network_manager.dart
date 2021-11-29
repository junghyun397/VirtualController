import 'dart:async';
import 'dart:io';

import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/data/database_provider.dart';
import 'package:vfcs/network/implemention/network_wifi.dart';
import 'package:vfcs/network/network_agent.dart';
import 'package:vfcs/network/network_interface.dart';
import 'package:vfcs/utility/disposable.dart';
import 'package:vfcs/utility/utility_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class NetworkManager implements Disposable {
  
  final SettingManager settingManager;

  final SQLite3Provider sqLite3Provider;

  late NetworkAgent targetNetworkAgent;

  final StreamController<bool> networkConditionStream = StreamController<bool>.broadcast();

  final List<NetworkData> _buffer = [];

  bool isConnected = false;

  NetworkManager(this.settingManager, this.sqLite3Provider);

  factory NetworkManager.fromNetworkType(NetworkType networkType, SettingManager settingManager, SQLite3Provider sqLite3Provider) {
    switch (networkType) {
      case NetworkType.WEB_SOCKET:
        return WifiNetworkManager(settingManager, sqLite3Provider);
      default:
        return WifiNetworkManager(settingManager, sqLite3Provider);
    }
  }

  static List<NetworkType> getAvailableInterfaceList() {
    return [NetworkType.WEB_SOCKET];
    // TODO: implement BLUETOOTH, USB_SERIAL
    // ignore: dead_code
    if (kIsWeb)
      return const [
        NetworkType.WEB_SOCKET,
      ];
    else if (Platform.isAndroid)
      return const [
        NetworkType.WEB_SOCKET,
        NetworkType.BLUETOOTH,
        NetworkType.USB_SERIAL,
      ];
    else if (Platform.isIOS)
      return const [
        NetworkType.WEB_SOCKET,
        NetworkType.BLUETOOTH,
      ];
    else
      return const [
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

  Future<List<String>> findAvailableServerList();

  Future<void> connectToTarget(String deviceAddress, Function() onSessionLost);

  void setConnectedCondition() {
    this.isConnected = true;
    this.networkConditionStream.add(true);
    if (this.settingManager.getSettingData(SettingType.AUTO_CONNECTION).value)
      this.sqLite3Provider.insertRegisteredDevices(this.targetNetworkAgent.address);
  }

  void setDisconnectedCondition() {
    this.isConnected = false;
    this.networkConditionStream.add(false);
  }

  void disconnectCurrentServer() {
    this.setDisconnectedCondition();
    this.targetNetworkAgent.killSession();
    this.isConnected = false;
  }

  void sendPacket(NetworkData networkData) {
    if (!this.isConnected) this._buffer.add(networkData);
    else if (this._buffer.isNotEmpty) {
      this._buffer.add(networkData);
      this._buffer.forEach((val) =>
          this.targetNetworkAgent.sendPacket(networkData));
      this._buffer.clear();
    } else this.targetNetworkAgent.sendPacket(networkData);
  }

  void startNotifyNetworkConditionToast() =>
    this.networkConditionStream.stream.listen((val) {
      if (val) SystemUtility.showToast("Connected with device.", backgroundColor: Colors.green);
      else SystemUtility.showToast("Disconnected with device.", backgroundColor: Colors.red);
    });

  Future<void> tryAutoReconnection() async {
    if ((!this.isConnected) && this.settingManager.getSettingData(SettingType.AUTO_CONNECTION).value) {
      List<String> registered = await SQLite3Provider().getSavedRegisteredDevices();
      await this.findAvailableServerList().then((val) => val.forEach((target) {
        if (registered.contains(target)) this.connectToTarget(target, () => null);
      }));
    }
  }
  
  @override
  void dispose() => this.networkConditionStream.close();
  
}