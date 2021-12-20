import 'dart:async';
import 'dart:convert';

import 'package:vfcs/data/database_provider.dart';
import 'package:vfcs/panel/component/component_definition.dart';
import 'package:vfcs/panel/panel_data.dart';
import 'package:vfcs/panel/panel_utility.dart';
import 'package:vfcs/utility/disposable.dart';
import 'package:vfcs/utility/utility_dart.dart';
import 'package:vfcs/utility/utility_system.dart';
import 'package:flutter/services.dart' show rootBundle;

class PanelManager implements Disposable {

  final DatabaseProvider _databaseProvider;

  final List<PanelData> panelList = List.empty(growable: true);

  final StreamController<PanelData> switchMainPanelStream = StreamController<PanelData>.broadcast();

  PanelManager(this._databaseProvider);

  Future<void> loadSavedPanelList() async {
    final Map<String, PanelData> panels = this._databaseProvider.getSavedPanelList();

    if (panels.length == 0) {
      final PanelData defaultPanelSetting = await this._getSavedDefaultPanel(PanelUtility.getMaxPanelSize(SystemUtility.physicalSize));
      this._databaseProvider.insertPanel("Default Panel", defaultPanelSetting);
      this.panelList.add(defaultPanelSetting);
    } else this.panelList.addAll(panels.values);
    this._sort();
  }

  PanelData getMainPanel() {
    if (this.panelList.length == 0) return getBasicPanelSetting(name: "NONE", width: 1, height: 1);
    return this.panelList[0];
  }

  void setAsMainPanel(PanelData panelSetting) {
    panelSetting.date = DateTime.now().millisecondsSinceEpoch;
    this.updatePanel(panelSetting);
    this._sort();
    this.switchMainPanelStream.add(panelSetting);
  }

  void insertPanel(PanelData panelSetting) {
    this.panelList.insert(0, panelSetting);
    this.updatePanel(panelSetting);
  }

  void updatePanel(PanelData panelSetting) {
    this.savePanel(panelSetting);
  }

  void savePanel(PanelData panelSetting) {
    this._databaseProvider.insertPanel(panelSetting.name, panelSetting);
  }

  void removeSavedPanel(String panelName) {
    this.panelList.removeAt(this.panelList.indexWhere((val) => val.name == panelName));
    this._databaseProvider.removePanel(panelName);
  }

  Future<PanelData> _getSavedDefaultPanel(Pair<int, int> maxPanelSize) async {
    final String size;
    if (maxPanelSize.a >= 12 && maxPanelSize.b >= 7) size = "large";
    else if (maxPanelSize.a >= 10 && maxPanelSize.b >= 6) size = "medium";
    else size = "small";
    return PanelData.fromJSON("Default Panel",
        jsonDecode(await rootBundle.loadString("assets/jsons/default_panel_$size.json")));
  }

  void _sort() => this.panelList.sort((a, b) => a.date > b.date ? -1 : 1);

  @override
  void dispose() => this.switchMainPanelStream.close();

}
