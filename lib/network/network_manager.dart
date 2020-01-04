import 'dart:io';

import 'package:VirtualFlightThrottle/network/network_agent.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

abstract class NetworkManager {

  bool isConnected = false;

  NetworkAgent _targetNetworkAgent;

  List<NetworkData> _buffer = [];

  void findAliveTargetList(Function(List<String>) onDone);

  void connectionToTarget(String targetAddress, Function() onConnected, Function() onSessionLost);

  void sendData(NetworkData networkData) {
    if (!this.isConnected) {
      this._buffer.add(networkData);
      return;
    }

    if (this._buffer.length != 0) {
      this._buffer.forEach((val) => this._targetNetworkAgent.sendData(val));
      this._buffer.clear();
    }

    this._targetNetworkAgent.sendData(networkData);
  }
  
}

class WifiNetworkManager extends NetworkManager {

  static const int port = 42424;

  @override
  void findAliveTargetList(Function(List<String>) onDone) {
    final stream = NetworkAnalyzer.discover2(
      '192.168.0', port,
      timeout: Duration(seconds: 5),
    );

    List<String> founds = [];
    stream.listen((NetworkAddress address) {
      if (address.exists) founds.add(address.ip);
    }).onDone(() => onDone(founds));
  }

  @override
  void connectionToTarget(String targetAddress, Function() onConnected, Function() onSessionLost) {
    Socket.connect(targetAddress, port).then((socket) {
      this._targetNetworkAgent = new WiFiNetworkAgent(socket);
      this.isConnected = true;
    }).catchError((e) {
      this.isConnected = false;
      onSessionLost();
    });
  }

}

class GlobalNetworkManager {

  static final GlobalNetworkManager _singleton = new GlobalNetworkManager._internal();
  factory GlobalNetworkManager() =>  _singleton;
  GlobalNetworkManager._internal();

  NetworkManager networkManager = new WifiNetworkManager();

  void connectNetwork() {
    this.networkManager.findAliveTargetList((val) => print(val.toString()));
    this.networkManager.connectionToTarget("10.0.2.2", () => print("CONNECTED!"), () => print("LOST!"));
  }

}