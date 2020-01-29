import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:VirtualFlightThrottle/network/network_manager.dart';
import 'package:flutter/material.dart';

class PanelController with ChangeNotifier {

  List<int> inputState = List<int>.filled(NetworkProtocol.ANALOGUE_INPUT_COUNT + NetworkProtocol.DIGITAL_INPUT_COUNT + 1, 0, growable: false);

  Map<int, int> _syncChain = Map<int, int>();

  PanelController() {
    this._syncAll();
  }

  bool hasAnalogueSync(int leftInput) =>
      this._syncChain.containsKey(leftInput);

  void switchAnalogueSync(int leftInput, int rightInput) {
    if (!this.hasAnalogueSync(leftInput)) this._syncChain.putIfAbsent(leftInput, () => rightInput);
    else this._syncChain.remove(leftInput);
    notifyListeners();
  }

  void eventAnalogue(int inputIndex, int value, {bool chain}) {
    if (inputIndex == 0 || this.inputState[inputIndex] == value) return;

    bool containKey = this._syncChain.containsKey(inputIndex);
    bool containValue = this._syncChain.containsValue(inputIndex);
    if (containKey || containValue) {
      if (chain == null && containKey && containValue) {
        eventAnalogue(this._syncChain[inputIndex], value, chain: true);
        eventAnalogue(this._syncChain.keys.where((key) => this._syncChain[key] == inputIndex).first, value, chain: false);
      } else if ((chain == null || chain) && containKey)
        eventAnalogue(this._syncChain[inputIndex], value, chain: true);
      else if ((chain == null || !chain) && containValue)
        eventAnalogue(this._syncChain.keys.where((key) => this._syncChain[key] == inputIndex).first, value, chain: false);
      notifyListeners();
    }

    if (inputIndex == 0) return;
    this.inputState[inputIndex] = value;
    AppNetworkManager().val.sendData(NetworkData(inputIndex, value));
  }

  void eventDigital(int inputIndex, bool value) {
    int serializeValue = value ? NetworkProtocol.DIGITAL_TRUE : NetworkProtocol.DIGITAL_FALSE;
    if (inputIndex == 0 || this.inputState[inputIndex] == serializeValue) return;

    this.inputState[inputIndex] = serializeValue;
    AppNetworkManager().val.sendData(NetworkData(inputIndex, serializeValue));
  }

  void _syncAll() =>
      this.inputState.asMap().forEach((idx, val) => AppNetworkManager().val.sendData(NetworkData(idx, val)));

}
