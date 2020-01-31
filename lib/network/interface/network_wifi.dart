import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

class WiFiNetworkAgent extends NetworkAgent {

  Socket _socket;

  WiFiNetworkAgent(this._socket, String address, Function onSessionKilled): super(address, onSessionKilled) {
    this._socket.handleError((error) {
      onSessionKilled();
    });
    this._socket.listen((event) {
      this.receiveData(utf8.decode(event));
    }, onError: (error) {
      this.killSession();
    }, onDone: () {
      this.killSession();
    });
  }

  @override
  void sendData(NetworkData networkData) {
    this._socket.add(utf8.encode(networkData.toString()));
  }

  @override
  void removeConnection() {
    this._socket.close();
  }
}

class WifiNetworkManager extends NetworkManager {

  static const int PORT = 10204;

  @override
  Future<bool> checkInterfaceAlive() async => await (Connectivity().checkConnectivity()) == ConnectivityResult.wifi;

  @override
  Future<String> getLocalAddress() async => await Connectivity().getWifiIP();

  @override
  Future<List<String>> findAliveTargetList() async {
    if (!await this.checkInterfaceAlive()) return Future.value([]);
    String ip = await this.getLocalAddress();
    final String subnet = ip.substring(0, ip.lastIndexOf("."));

    final stream = NetworkAnalyzer.discover2(
      subnet, PORT,
      timeout: Duration(milliseconds: AppSettings().settingsMap[SettingsType.NETWORK_TIMEOUT].value),
    );

    Completer<List<String>> completer = Completer<List<String>>();

    List<String> founds = [];
    stream.listen((NetworkAddress address) {
      if (address.exists) founds.add(address.ip);
    }).onDone(() => completer.complete(founds));

    return completer.future;
  }

  @override
  Future<void> connectToTarget(String deviceAddress,
      Function() onSessionFail) async {
    if (this.isConnected) return this.disconnectCurrentTarget();

    Completer<void> completer = Completer<void>();

    Function() onSessionKilled = this.setDisconnectedState;

    Socket.connect(deviceAddress, PORT).then((socket) {
      this.targetNetworkAgent = WiFiNetworkAgent(socket, deviceAddress, onSessionKilled);
      this.setConnectedState();
      completer.complete();
    }).catchError((e) {
      onSessionFail();
    }).timeout(Duration(milliseconds: AppSettings().settingsMap[SettingsType.NETWORK_TIMEOUT].value), onTimeout: () {
      onSessionFail();
    });

    return completer.future;
  }

  @override
  String toString() => "WiFi";

}