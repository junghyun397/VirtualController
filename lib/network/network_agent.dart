import 'dart:convert';
import 'dart:io';

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

  void sendData(NetworkData networkData);

  void killSession();

}

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