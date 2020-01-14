import 'package:VirtualFlightThrottle/data/data_app_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
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

  Future<void> tryAutoReconnection() async {
    if ((!this.val.isConnected) && AppSettings().settingsMap[SettingsType.AUTO_CONNECTION].value) {
      List<String> registered = await SQLite3Helper().getSavedRegisteredDevices();
      this.val.findAliveTargetList().then((val) {
        val.forEach((target) {
          if (registered.contains(target)) this.val.connectToTarget(target, () => null);
        });
      });
    }
  }

}