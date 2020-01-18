import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:VirtualFlightThrottle/network/network_app_manager.dart';
import 'package:flutter/material.dart';

class PanelController with ChangeNotifier {

  List<int> _inputState = List<int>(NetworkProtocol.ANALOGUE_INPUT_COUNT + NetworkProtocol.DIGITAL_INPUT_COUNT);

  Map<int, int> _syncWith = Map<int, int>();

  void enableSync({int sourceInput, int targetInput, bool enable}) {
    if (enable) this._syncWith.putIfAbsent(sourceInput, () => targetInput);
    else this._syncWith.remove(sourceInput);
  }

  void eventAnalogue(int inputIndex, int value) {
    if (inputIndex == -1) return;

    if (this._syncWith.containsKey(inputIndex)) {
      this.eventAnalogue(this._syncWith[inputIndex], value);
      notifyListeners();
    }
    this._inputState[inputIndex] = value;
    AppNetworkManager().val.sendData(NetworkData(inputIndex, value));
  }

  void eventDigital(int inputIndex, bool value) {
    if (inputIndex == -1) return;

    this._inputState[inputIndex] = value ? NetworkProtocol.DIGITAL_TRUE : NetworkProtocol.DIGITAL_FALSE;
    AppNetworkManager().val.sendData(NetworkData(inputIndex, value ? NetworkProtocol.DIGITAL_TRUE : NetworkProtocol.DIGITAL_FALSE));
  }

  void _syncAll() {
    this._inputState.asMap().forEach((idx, val) {
      if (val < NetworkProtocol.ANALOGUE_INPUT_COUNT) AppNetworkManager().val.sendData(NetworkData(idx, val));
      else AppNetworkManager().val.sendData(NetworkData(idx, val));
    });
  }

}
