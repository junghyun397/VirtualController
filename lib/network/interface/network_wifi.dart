import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:VirtualFlightThrottle/network/network_manager.dart';
import 'package:connectivity/connectivity.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class WiFiNetworkAgent extends NetworkAgent {

  final Socket _socket;

  WiFiNetworkAgent(this._socket, int timeOut, String address, Function onSessionKilled): super(address, timeOut, onSessionKilled) {
    this._socket.handleError((error) => onSessionKilled());
    this._socket.listen(
      (event) => this.receiveData(utf8.decode(event)),
      onError: (error) => this.killSession(),
      onDone: () => this.killSession(),
    );
  }

  @override
  void sendData(NetworkData networkData) => this._socket.add(utf8.encode(networkData.toString()));

  @override
  void removeConnection() => this._socket.close();
}

class WifiNetworkManager extends NetworkManager {

  static const int PORT = 10204;

  WifiNetworkManager(SettingManager settingManager) : super(settingManager);

  @override
  Future<bool> checkInterfaceAlive() async => await (Connectivity().checkConnectivity()) == ConnectivityResult.wifi;

  Future<String> getLocalAddress() async => await WifiInfo().getWifiIP();

  @override
  Future<List<String>> findAliveTargetList() async {
    return Future.value();
  }

  @override
  Future<void> connectToTarget(String deviceAddress, Function() onSessionFail) async {
    if (this.isConnected) return this.disconnectCurrentTarget();

    return Socket.connect(deviceAddress, PORT).then((socket) {
      this.targetNetworkAgent = WiFiNetworkAgent(socket,
          this.settingManager.settingsMap[SettingsType.NETWORK_TIMEOUT].value, deviceAddress, this.setDisconnectedState);
      this.setConnectedState();
    }).catchError((e) => onSessionFail())
        .timeout(Duration(milliseconds: this.settingManager.settingsMap[SettingsType.NETWORK_TIMEOUT].value),
      onTimeout: () => onSessionFail(),
    );
  }

}