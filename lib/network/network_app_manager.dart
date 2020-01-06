import 'package:VirtualFlightThrottle/data/data_app_settings.dart';
import 'package:VirtualFlightThrottle/network/interface/network_bluetooth.dart';
import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:VirtualFlightThrottle/network/interface/network_wifi.dart';

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

}