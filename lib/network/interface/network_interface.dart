import 'dart:async';

import 'package:VirtualFlightThrottle/data/data_app_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';

class NetworkProtocol {
  static const int PASS = -1;
  static const int VALIDATION = -2;

  static const int ANALOGUE_INPUT_COUNT = 10;
  static const int DIGITAL_INPUT_COUNT = 100;

  static const int DIGITAL_TRUE = 1;
  static const int DIGITAL_FALSE = 0;
}

class NetworkData {
  int targetInput;
  int value;

  NetworkData(this.targetInput, this.value);

  @override
  String toString() {
    return targetInput.toString()+":"+value.toString();
  }
}

class ValidationNetworkData extends NetworkData {
  ValidationNetworkData() : super(NetworkProtocol.VALIDATION, DateTime.now().millisecondsSinceEpoch);
}

abstract class NetworkAgent {

  String address;

  Function onSessionKilled;
  bool killed = false;

  NetworkAgent(this.address, this.onSessionKilled) {
    this._startValidationSession();
  }

  void sendData(NetworkData networkData);

  void receiveData(String data) {}

  void killSession() {
    this.killed = true;
    this.removeConnection();
    this.onSessionKilled();
  }

  void removeConnection();

  void _startValidationSession() {
        () async {
      while (!this.killed) {
        this.sendData(ValidationNetworkData());
        await Future.delayed(Duration(milliseconds: AppSettings().settingsMap[SettingsType.NETWORK_TIMEOUT].value));
      }
    }();
  }

}

abstract class NetworkManager {

  bool isConnected = false;

  // ignore: close_sinks
  StreamController<bool> networkStateStreamController = StreamController<
      bool>.broadcast();

  NetworkAgent targetNetworkAgent;

  List<NetworkData> _buffer = [];

  Future<bool> checkInterfaceAlive();

  Future<String> getLocalAddress();

  Future<List<String>> findAliveTargetList();

  Future<void> connectToTarget(String deviceAddress, Function() onSessionLost);

  void setConnectedState() {
    this.isConnected = true;
    this.networkStateStreamController.add(true);
    if (AppSettings().settingsMap[SettingsType.AUTO_CONNECTION].value)
      SQLite3Helper().insertRegisteredDevices(this.targetNetworkAgent.address);
  }

  void setDisconnectedState() {
    this.isConnected = false;
    this.networkStateStreamController.add(false);
  }

  void disconnectCurrentTarget() {
    this.setDisconnectedState();
    this.targetNetworkAgent.killSession();
    this.isConnected = false;
  }

  void sendData(NetworkData networkData) {
    if (!this.isConnected) {
      this._buffer.add(networkData);
      return;
    }

    this.targetNetworkAgent.sendData(networkData);
  }
}