import 'dart:async';

import 'package:VirtualFlightThrottle/data/data_app_settings.dart';
import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';


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

abstract class NetworkAgent {

  String address;

  NetworkAgent(this.address);

  void sendData(NetworkData networkData);

  void killSession();

}

abstract class NetworkManager {

  bool isConnected = false;

  // ignore: close_sinks
  StreamController<bool> networkStateStreamController = StreamController<bool>();

  NetworkAgent targetNetworkAgent;

  List<NetworkData> _buffer = [];

  Future<List<String>> findAliveTargetList();

  Future<void> connectToTarget(String targetAddress, Function() onSessionLost);
  
  void setConnectedState() {
    this.isConnected = true;
    this.networkStateStreamController.add(true);
    if (AppSettings().settingsMap[SettingsType.AUTO_CONNECTION].value)
      SQLite3Helper().insertRegisteredDevices(this.targetNetworkAgent.address);
  }

  void disconnectCurrentTarget() {
    if (!this.isConnected) return;
    this.targetNetworkAgent.killSession();
    this.networkStateStreamController.add(false);
    this.isConnected = false;
  }

  void sendData(NetworkData networkData) {
    if (!this.isConnected) {
      this._buffer.add(networkData);
      return;
    }

    if (this._buffer.length != 0) {
      this._buffer.forEach((val) => this.targetNetworkAgent.sendData(val));
      this._buffer.clear();
    }

    this.targetNetworkAgent.sendData(networkData);
  }
}