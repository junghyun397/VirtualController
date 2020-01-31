import 'dart:async';

import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';

class NetworkProtocol {
  static const int PASS = 0;
  static const int VALIDATION = -2;

  static const int ANALOGUE_INPUT_COUNT = 8;
  static const int DIGITAL_INPUT_COUNT = 128;

  static const int DIGITAL_TRUE = 1;
  static const int DIGITAL_FALSE = 0;
}

class NetworkData<T> {
  final int targetInput;
  final T value;

  NetworkData(this.targetInput, this.value);

  @override
  String toString() => "d${targetInput.toString()}:${value.toString()}";

  static NetworkData parsePacket(String packet) {
    final List<String> splitted = packet.split(":");
    if (splitted.length == 2) {
      final int targetInput = int.parse(splitted[0]);
      if (targetInput == NetworkProtocol.VALIDATION) return NetworkData<String>(targetInput, splitted[1]);
      else return NetworkData<int>(targetInput, 0);
    } else return NetworkData<int>(NetworkProtocol.PASS, 0);
  }
}

class ValidationNetworkData extends NetworkData {
  ValidationNetworkData() : super(NetworkProtocol.VALIDATION,
      "${AppSettings().settingsMap[SettingsType.USER_NAME].value}/${DateTime.now().millisecondsSinceEpoch}");
}

abstract class NetworkAgent {

  String address;

  Function onSessionKilled;
  bool killed = false;

  int _currentValidationReceiveTime = 0;
  int _prvValidationReceiveTime = 0;

  NetworkAgent(this.address, this.onSessionKilled) {
    this._startValidationSession();
  }

  void sendData(NetworkData networkData);

  void receiveData(String data) {
    final NetworkData networkData = NetworkData.parsePacket(data);
    if (networkData.targetInput == NetworkProtocol.VALIDATION) {
      this._prvValidationReceiveTime = this._currentValidationReceiveTime;
      this._currentValidationReceiveTime = int.parse(networkData.value.split("/")[1]);
    }
  }

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
        if (this._prvValidationReceiveTime == this._currentValidationReceiveTime) this.killSession();
      }
    }();
  }

}

abstract class NetworkManager {

  bool isConnected = false;

  // ignore: close_sinks
  StreamController<bool> networkStateStreamController = StreamController<bool>.broadcast();

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
    if (!this.isConnected) this._buffer.add(networkData);
    else if (this._buffer.isNotEmpty) {
      this._buffer.add(networkData);
      this._buffer.forEach((val) => this.targetNetworkAgent.sendData(networkData));
      this._buffer.clear();
    }
    else this.targetNetworkAgent.sendData(networkData);
  }
}