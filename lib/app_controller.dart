import 'package:VirtualFlightThrottle/data/data_settings.dart';
import 'package:VirtualFlightThrottle/data/sqlite3_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'network/network_manager.dart';

class AppManager with ChangeNotifier {

  final SQLite3Manager sqlite3Manager;
  final SettingManager settingManager;
  final NetworkManager networkManager;
  final PanelManager panelManager;

  AppManager(this.sqlite3Manager, this.settingManager, this.networkManager, this.panelManager);

  static AppManager byContext(BuildContext context) => Provider.of<AppManager>(context);

  void switchTheme() {
    notifyListeners();
  }

}