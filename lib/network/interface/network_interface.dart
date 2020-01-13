import 'dart:async';


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