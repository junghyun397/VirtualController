import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';
import 'package:flutter/material.dart';

class BlueToothNetworkAgent extends NetworkAgent {

  BlueToothNetworkAgent(String address, Function onSessionKilled): super(address, onSessionKilled);

  @override
  void sendData(NetworkData networkData) {}

  @override
  void removeConnection() {}
}

class BlueToothNetworkManager extends NetworkManager {

  @override
  Future<bool> checkInterfaceAlive() async => Future<bool>.value(false);

  @override
  Future<List<String>> findAliveTargetList() async {return Future.value([]);}

  @override
  Future<void> connectToTarget(String targetAddress, Function() onSessionLost) async {return Future.value();}

  @override
  String getInterfaceName() => "Bluetooth";

  @override
  IconData getInterfaceIcon() => Icons.bluetooth;

}