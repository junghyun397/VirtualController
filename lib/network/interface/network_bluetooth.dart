import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/network/interface/network_interface.dart';

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
  NetworkType getInterfaceType() => NetworkType.BLUETOOTH;

}