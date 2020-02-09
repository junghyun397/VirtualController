import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';

class USBSerialNetworkAgent extends NetworkAgent {

  USBSerialNetworkAgent(String address, Function onSessionKilled): super(address, onSessionKilled);

  @override
  void sendData(NetworkData networkData) {}

  @override
  void removeConnection() {}
}

class USBSerialNetworkManager extends NetworkManager {

  @override
  Future<bool> checkInterfaceAlive() async => Future<bool>.value(false);

  @override
  Future<String> getLocalAddress() async => Future<String>.value("None");

  @override
  Future<List<String>> findAliveTargetList() async {return Future.value([]);}

  @override
  Future<void> connectToTarget(String targetAddress, Function() onSessionLost) async {return Future.value();}

  @override
  String toString() => "USB";

}