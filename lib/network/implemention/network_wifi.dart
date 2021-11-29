import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/data/database_provider.dart';
import 'package:vfcs/network/network_agent.dart';
import 'package:vfcs/network/network_interface.dart';
import 'package:vfcs/network/network_manager.dart';
import 'package:connectivity/connectivity.dart';

class WiFiNetworkAgent extends NetworkAgent {

  final Socket _socket;

  WiFiNetworkAgent(this._socket, int timeOut, String address, Function onSessionKilled): super(address, timeOut, onSessionKilled) {
    this._socket.handleError((error) => onSessionKilled());
    this._socket.listen(
      (event) => this.processPacket(event),
      onError: (error) => this.killSession(),
      onDone: () => this.killSession(),
    );
  }

  @override
  void sendPacket(NetworkData networkData) => this._socket.add(utf8.encode(networkData.toString()));

  @override
  void removeConnection() => this._socket.close();
}

class WifiNetworkManager extends NetworkManager {

  static const int PORT = 10204;

  WifiNetworkManager(SettingManager settingManager, SQLite3Provider sqLite3Provider) : super(settingManager, sqLite3Provider);

  @override
  Future<bool> checkInterfaceAlive() async => await (Connectivity().checkConnectivity()) == ConnectivityResult.wifi;

  Future<String> getLocalAddress() async => Future.value(""); // TODO: implement

  @override
  Future<List<String>> findAvailableServerList() async => Future.value(List.empty()); // TODO: implement

  @override
  Future<void> connectToTarget(String deviceAddress, Function() onSessionFail) async {
    if (this.isConnected) return this.disconnectCurrentServer();

    return Socket.connect(deviceAddress, PORT).then((socket) {
      this.targetNetworkAgent = WiFiNetworkAgent(socket,
          this.settingManager.getSettingData(SettingType.NETWORK_TIMEOUT).value, deviceAddress, this.setDisconnectedCondition);
      this.setConnectedCondition();
    }).catchError((e) => onSessionFail())
        .timeout(Duration(milliseconds: this.settingManager.getSettingData(SettingType.NETWORK_TIMEOUT).value),
      onTimeout: () => onSessionFail(),
    );
  }

}