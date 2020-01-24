import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';

class PagePanelListController with ChangeNotifier {

  void insertPanel(PanelSetting panelSetting) {
    AppPanelManager().insertPanel(panelSetting);
    notifyListeners();
  }

  void removePanel(String panelName) {
    AppPanelManager().removeSavedPanel(panelName);
    notifyListeners();
  }

}