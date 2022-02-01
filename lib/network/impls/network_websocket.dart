import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/data/database_provider.dart';
import 'package:vfcs/network/network_agent.dart';
import 'package:vfcs/network/network_interface.dart';
import 'package:vfcs/network/network_manager.dart';
import 'package:connectivity/connectivity.dart';

class WebSocketNetworkAgent extends NetworkAgent {

  final Socket _socket;

  WebSocketNetworkAgent(this._socket, int timeOut, String address, Function onSessionKilled): super(address, timeOut, onSessionKilled) {
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

class WebSocketManager extends NetworkManager {

  static const int PORT = 10204;

  WebSocketManager(SettingsProvider settingsProvider, DatabaseProvider databaseProvider) : super(settingsProvider, databaseProvider);

  @override
  Future<bool> checkInterfaceAvailable() async => await (Connectivity().checkConnectivity()) == ConnectivityResult.wifi;

  Future<String> getLocalAddress() async => Future.value(""); // TODO: implement

  @override
  Future<List<String>> discoverAvailableServers() async => Future.value(List.empty()); // TODO: implement

  @override
  Future<void> connectByAddress(String serverAddress, {Function()? onSessionLost}) async {
    if (this.networkCondition == NetworkCondition.CONNECTED) return this.disconnectCurrentServer();

    return Socket.connect(serverAddress, PORT).then((socket) {
      this.networkAgent = WebSocketNetworkAgent(socket,
          this.settingsProvider.getSettingData(SettingType.NETWORK_TIMEOUT).value, serverAddress, this.setDisconnectedCondition);
      this.setConnectedCondition();
    }).catchError((e) => onSessionLost != null ? onSessionLost() : null)
        .timeout(Duration(milliseconds: this.settingsProvider.getSettingData(SettingType.NETWORK_TIMEOUT).value),
      onTimeout: () => onSessionLost != null ? onSessionLost() : null,
    );
  }

}