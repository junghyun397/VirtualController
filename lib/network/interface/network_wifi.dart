import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

class WiFiNetworkAgent extends NetworkAgent {

  Socket _socket;

  WiFiNetworkAgent(this._socket);

  @override
  void sendData(NetworkData networkData) {
    this._socket.add(utf8.encode(networkData.toString()));
  }

  @override
  void killSession() {
    this._socket.close();
  }

}

class WifiNetworkManager extends NetworkManager {

  static const int _port = 42424;

  static const int _timeout = 3;

  static Future<bool> checkWifiConnection() async {
    return await (Connectivity().checkConnectivity()) == ConnectivityResult.wifi;
  }

  static Future<String> getIPAddress() async {
    return await Connectivity().getWifiIP();
  }

  @override
  Future<List<String>> findAliveTargetList() async {
    if (!await checkWifiConnection()) return Future.value([]);
    String ip = await getIPAddress();
    final String subnet = ip.substring(0, ip.lastIndexOf("."));

    final stream = NetworkAnalyzer.discover2(
      subnet, _port,
      timeout: Duration(seconds: _timeout),
    );

    Completer<List<String>> completer = new Completer<List<String>>();

    List<String> founds = [];
    stream.listen((NetworkAddress address) {
      if (address.exists) founds.add(address.ip);
    }).onDone(() => completer.complete(founds));

    return completer.future;
  }

  @override
  Future<void> connectToTarget(String targetAddress, Function() onSessionLost) async {
    Completer<void> completer = new Completer<void>();

    Socket.connect(targetAddress, _port).then((socket) {
      this.targetNetworkAgent = new WiFiNetworkAgent(socket);
      this.isConnected = true;
      completer.complete();
    }).catchError((e) {
      this.isConnected = false;
      onSessionLost();
    });

    return completer.future;
  }

  @override
  String toString() {
    return "WiFi";
  }

}