import 'dart:async';

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
    final List<String> splatted = packet.split(":");
    if (splatted.length == 2) {
      final int targetInput = int.parse(splatted[0]);
      if (targetInput == NetworkProtocol.VALIDATION) return NetworkData<String>(targetInput, splatted[1]);
      else return NetworkData<int>(targetInput, 0);
    } else return NetworkData<int>(NetworkProtocol.PASS, 0);
  }
}

class ValidationNetworkData extends NetworkData {
  ValidationNetworkData() : super(NetworkProtocol.VALIDATION,
      "VFCS/${DateTime.now().millisecondsSinceEpoch}");
}

abstract class NetworkAgent {

  final String address;
  final int timeOut;

  final Function onSessionKilled;
  bool killed = false;

  int _currentValidationReceiveTime = 0;
  int _prvValidationReceiveTime = 0;

  NetworkAgent(this.address, this.timeOut, this.onSessionKilled) {
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

  Future<void> _startValidationSession() async {
    while (!this.killed) {
      this.sendData(ValidationNetworkData());
      await Future.delayed(Duration(milliseconds: this.timeOut));
      if (this._prvValidationReceiveTime == this._currentValidationReceiveTime) this.killSession();
    }
  }

}