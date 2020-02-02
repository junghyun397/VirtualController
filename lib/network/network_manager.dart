import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:VirtualFlightThrottle/network/interface/network_bluetooth.dart';
import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:VirtualFlightThrottle/network/interface/network_wifi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppNetworkManager {

  static final AppNetworkManager _singleton = new AppNetworkManager._internal();
  factory AppNetworkManager() => _singleton;
  AppNetworkManager._internal();

  NetworkManager val = _getNetworkManager();

  static NetworkManager _getNetworkManager() {
    switch (AppSettings().settingsMap[SettingsType.NETWORK_TYPE].value) {
      case NetworkType.WIFI:
        return new WifiNetworkManager();
      case NetworkType.BLUETOOTH:
        return new BlueToothNetworkManager();
      default:
        return new WifiNetworkManager();
    }
  }

  void startNotifyNetworkStateToast() {
    this.val.networkStateStreamController.stream.listen((val) {
      if (val)
        Fluttertoast.showToast(
          msg: "Connected with device.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      else {
        Fluttertoast.showToast(
          msg: "Disconnected with device.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  Future<void> tryAutoReconnection() async {
    if ((!this.val.isConnected) && AppSettings().settingsMap[SettingsType.AUTO_CONNECTION].value) {
      List<String> registered = await SQLite3Helper().getSavedRegisteredDevices();
      await this.val.findAliveTargetList().then((val) => val.forEach((target) {
            if (registered.contains(target)) this.val.connectToTarget(target, () => null);
      }));
    }
  }
}