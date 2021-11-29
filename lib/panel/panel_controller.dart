import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/network/network_interface.dart';
import 'package:vfcs/network/network_manager.dart';
import 'package:flutter/material.dart';

class PanelController with ChangeNotifier {

  final NetworkManager networkManager;
  final SettingManager settingManager;

  final List<int> inputState = List<int>
      .filled(NetworkProtocol.ANALOGUE_INPUT_COUNT + NetworkProtocol.DIGITAL_INPUT_COUNT + 1, 0, growable: false);

  final Map<int, int> _couplingState = Map<int, int>();

  PanelController(this.networkManager, this.settingManager) {
    this._syncAll();
  }

  bool hasAnalogueSync(int leftInput) =>
      this._couplingState.containsKey(leftInput);

  void switchAnalogueSync(int leftInput, int rightInput) {
    if (!this.hasAnalogueSync(leftInput)) this._couplingState.putIfAbsent(leftInput, () => rightInput);
    else this._couplingState.remove(leftInput);
    this.notifyListeners();
  }

  // P = contain key, Q = contain value, R = oc is null, S = oc
  // if P or Q
  //   if P and Q and R
  //     job1, job2
  //   if P and (R or S)
  //     job1
  //   if (R or !S) and Q
  //     job2

  // if P and Q and R
  //   job0, job1, job2
  // if P and (R or S)
  //   job0, job1
  // if Q and (R or not S)
  //   job0, job2

  void eventAnalogue(int inputIndex, int value, {bool? onCoupling}) {
    if (inputIndex == 0 || this.inputState[inputIndex] == value) return;

    final bool containKey = this._couplingState.containsKey(inputIndex);
    final bool containValue = this._couplingState.containsValue(inputIndex);

    if (containKey || containValue) {
      if (containKey && containValue && onCoupling == null) {
        this.eventAnalogue(this._couplingState[inputIndex]!, value, onCoupling: true);
        this.eventAnalogue(this._couplingState.keys
            .where((key) => this._couplingState[key] == inputIndex).first, value, onCoupling: false);
      } else if (containKey && (onCoupling == null || onCoupling))
        this.eventAnalogue(this._couplingState[inputIndex]!, value, onCoupling: true);
      else if (containValue && (onCoupling == null || !onCoupling))
        this.eventAnalogue(this._couplingState.keys
            .where((key) => this._couplingState[key] == inputIndex).first, value, onCoupling: false);
      notifyListeners();
    }
    
    this.inputState[inputIndex] = value;
    this.networkManager.sendPacket(IntegerNetworkData(inputIndex, value));
  }

  void eventDigital(int inputIndex, bool value) {
    final int serializeValue = value ? NetworkProtocol.DIGITAL_TRUE : NetworkProtocol.DIGITAL_FALSE;
    if (inputIndex == 0 || this.inputState[inputIndex] == serializeValue) return;

    this.inputState[inputIndex] = serializeValue;
    this.networkManager.sendPacket(IntegerNetworkData(inputIndex, serializeValue));
  }

  void _syncAll() =>
      this.inputState.asMap().forEach((idx, val) => this.networkManager.sendPacket(IntegerNetworkData(idx, val)));

}
