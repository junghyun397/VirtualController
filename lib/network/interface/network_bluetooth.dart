import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';

class BlueToothNetworkAgent extends NetworkAgent {

  @override
  void killSession() {}

  @override
  void sendData(NetworkData networkData) {}
}

class BlueToothNetworkManager extends NetworkManager {

  @override
  Future<List<String>> findAliveTargetList() async {return Future.value([]);}

  @override
  Future<void> connectToTarget(String targetAddress, Function() onSessionLost) async {return Future.value();}

  @override
  String toString() {
    return "Bluetooth";
  }

}