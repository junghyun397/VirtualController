import 'package:VirtualFlightThrottle/panel/panel_manager.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:flutter/material.dart';

class PagePanelListController with ChangeNotifier {

  void setAsMainPanel(PanelSetting panelSetting) {
    PanelManager().setAsMainPanel(panelSetting);
    notifyListeners();
  }

  void insertPanel(PanelSetting panelSetting) {
    PanelManager().insertPanel(panelSetting);
    notifyListeners();
  }

  void removePanel(String panelName) {
    PanelManager().removeSavedPanel(panelName);
    notifyListeners();
  }

}