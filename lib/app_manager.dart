import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/data/database_provider.dart';
import 'package:vfcs/panel/panel_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:vfcs/utility/disposable.dart';

import 'network/network_manager.dart';

class AppManager with ChangeNotifier implements Disposable {

  final DatabaseProvider databaseProvider;
  final SettingsProvider settingProvider;
  final NetworkManager networkManager;
  final PanelManager panelManager;

  AppManager(this.databaseProvider, this.settingProvider, this.networkManager, this.panelManager);

  static AppManager byContext(BuildContext context) => Provider.of<AppManager>(context);

  void switchTheme() => notifyListeners();

  @override
  void dispose() {
    this.databaseProvider.dispose();
    this.settingProvider.dispose();
    
    this.networkManager.dispose();
    this.panelManager.dispose();
    super.dispose();
  }

}