import 'package:vfcs/panel/panel_manager.dart';
import 'package:vfcs/panel/panel_data.dart';
import 'package:flutter/material.dart';

class PagePanelListController with ChangeNotifier {

  void setAsMainPanel(PanelData panelSetting) {
    PanelManager().setAsMainPanel(panelSetting);
    notifyListeners();
  }

  void insertPanel(PanelData panelSetting) {
    PanelManager().insertPanel(panelSetting);
    notifyListeners();
  }

  void removePanel(String panelName) {
    PanelManager().removeSavedPanel(panelName);
    notifyListeners();
  }

}