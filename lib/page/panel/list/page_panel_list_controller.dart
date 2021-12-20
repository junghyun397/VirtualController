import 'package:vfcs/panel/panel_manager.dart';
import 'package:vfcs/panel/panel_data.dart';
import 'package:flutter/material.dart';

class PagePanelListController with ChangeNotifier {

  final PanelManager _panelManager;

  PagePanelListController(this._panelManager);

  void setAsMainPanel(PanelData panelSetting) {
    this._panelManager.setAsMainPanel(panelSetting);
    this.notifyListeners();
  }

  void insertPanel(PanelData panelSetting) {
    this._panelManager.insertPanel(panelSetting);
    this.notifyListeners();
  }

  void removePanel(String panelName) {
    this._panelManager.removeSavedPanel(panelName);
    this.notifyListeners();
  }

}