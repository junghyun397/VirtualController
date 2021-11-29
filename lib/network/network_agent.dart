import 'dart:typed_data';

import 'package:vfcs/network/network_interface.dart';

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

  void sendPacket(NetworkData networkData);

  void processPacket(Uint8List event) => null;

  void killSession() {
    this.killed = true;
    this.removeConnection();
    this.onSessionKilled();
  }

  void removeConnection();

  Future<void> _startValidationSession() async {
    while (!this.killed) {
      this.sendPacket(ValidationNetworkData());
      await Future.delayed(Duration(milliseconds: this.timeOut));
      if (this._prvValidationReceiveTime == this._currentValidationReceiveTime) this.killSession();
    }
  }

}