import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:VirtualFlightThrottle/network/network_app_manager.dart';
import 'package:flutter/material.dart';

class PanelController with ChangeNotifier {
  static const int _analogue_input_count = 10;
  static const int _digital_input_count = 100;
  static const double _digital_true_as = 0;
  static const double _digital_false_as = -1;

  List<double> _inputState =
      List<double>(_analogue_input_count + _digital_input_count);

  Map<int, int> _syncWith = Map<int, int>();

  void enableSync({int sourceInput, int targetInput, bool enable}) {
    if (enable)
      this._syncWith.putIfAbsent(sourceInput, () => targetInput);
    else
      this._syncWith.remove(sourceInput);
  }

  void eventAnalogue(int inputIndex, double value) {
    if (this._syncWith.containsKey(inputIndex)) {
      this.eventAnalogue(this._syncWith[inputIndex], value);
      notifyListeners();
    }
    this._inputState[inputIndex] = value;
    AppNetworkManager().val.sendData(AxesNetworkData(inputIndex, value));
  }

  void eventDigital(int inputIndex, bool value) {
    this._inputState[inputIndex] = value ? _digital_true_as : _digital_false_as;
    AppNetworkManager().val.sendData(ButtonNetworkData(inputIndex, value));
  }

  void _syncAll() {
    this._inputState.asMap().forEach((idx, val) {
      if (val < _analogue_input_count)
        AppNetworkManager().val.sendData(AxesNetworkData(idx, val));
      else
        AppNetworkManager().val.sendData(
            ButtonNetworkData(idx, val == _digital_true_as ? true : false));
    });
  }
}
