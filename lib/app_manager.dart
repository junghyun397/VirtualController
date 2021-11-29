import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/data/database_provider.dart';
import 'package:vfcs/panel/panel_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'network/network_manager.dart';

class AppManager with ChangeNotifier {

  final SQLite3Provider sqlite3Manager;
  final SettingManager settingManager;
  final NetworkManager networkManager;
  final PanelManager panelManager;

  AppManager(this.sqlite3Manager, this.settingManager, this.networkManager, this.panelManager);

  static AppManager byContext(BuildContext context) => Provider.of<AppManager>(context);

  void switchTheme() {
    notifyListeners();
  }

}