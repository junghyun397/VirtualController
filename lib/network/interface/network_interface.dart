import 'dart:async';

import 'package:VirtualFlightThrottle/data/data_app_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:flutter/cupertino.dart';

class NetworkData<T> {
  int targetInput;
  T value;

  NetworkData(this.targetInput, this.value);

  @override
  String toString() {
    return targetInput.toString()+":"+value.toString();
  }
}

class AxesNetworkData extends NetworkData<double> {
  AxesNetworkData(int targetInput, double value) : super(targetInput, value);
}

class ButtonNetworkData extends NetworkData<bool> {
  ButtonNetworkData(int targetInput, bool value) : super(targetInput, value);
}

class ValidationNetworkData extends NetworkData<int> {
  ValidationNetworkData() : super(-1, DateTime
      .now()
      .millisecondsSinceEpoch);
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
        await Future.delayed(Duration(
            milliseconds: AppSettings().settingsMap[SettingsType
                .NETWORK_TIMEOUT].value));
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