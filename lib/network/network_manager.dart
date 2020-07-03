import 'dart:io';

import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:VirtualFlightThrottle/network/interface/network_bluetooth.dart';
import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:VirtualFlightThrottle/network/interface/network_usb_serial.dart';
import 'package:VirtualFlightThrottle/network/interface/network_wifi.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:flutter/material.dart';

class AppNetworkManager {

  static final AppNetworkManager _singleton = new AppNetworkManager._internal();
  factory AppNetworkManager() => _singleton;
  AppNetworkManager._internal();

  NetworkManager val = _getNetworkManager();

  static NetworkManager _getNetworkManager() {
    switch (AppSettings().settingsMap[SettingsType.NETWORK_TYPE].value) {
      case NetworkType.WIFI:
        return WifiNetworkManager();
      case NetworkType.BLUETOOTH:
        return BlueToothNetworkManager();
      case NetworkType.USB_SERIAL:
        return USBSerialNetworkManager();
      default:
        return WifiNetworkManager();
    }
  }

  List<NetworkType> getAvailableInterfaceList() {
    if (Platform.isAndroid) return [NetworkType.WIFI, NetworkType.BLUETOOTH, NetworkType.USB_SERIAL];
    else if (Platform.isIOS) return [NetworkType.WIFI, NetworkType.BLUETOOTH];
    else return [NetworkType.WIFI];
  }

  void startNotifyNetworkStateToast() =>
    this.val.networkStateStreamController.stream.listen((val) {
      if (val) SystemUtility.showToast(message: "Connected with device.", backgroundColor: Colors.green);
      else SystemUtility.showToast(message: "Disconnected with device.", backgroundColor: Colors.red);
    });

  Future<void> tryAutoReconnection() async {
    if ((!this.val.isConnected) && AppSettings().settingsMap[SettingsType.AUTO_CONNECTION].value) {
      List<String> registered = await SQLite3Helper().getSavedRegisteredDevices();
      await this.val.findAliveTargetList().then((val) => val.forEach((target) {
        if (registered.contains(target)) this.val.connectToTarget(target, () => null);
      }));
    }
  }
}