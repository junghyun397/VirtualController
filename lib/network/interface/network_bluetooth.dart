import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';

class BlueToothNetworkAgent extends NetworkAgent {

  BlueToothNetworkAgent(String address, Function onSessionKilled)
      : super(address, onSessionKilled);

  @override
  void sendData(NetworkData networkData) {}

  @override
  void removeConnection() {}
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