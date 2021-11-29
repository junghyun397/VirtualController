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

  final SQLite3Provider sqLite3Manager;

  final List<PanelData> panelList = List.empty(growable: true);

  final StreamController mainPanelStream = StreamController<PanelData>.broadcast();

  PanelManager(this.sqLite3Manager);

  Future<void> loadSavedPanelList() async {
    await this.sqLite3Manager.getSavedPanelList().then((val) async {
      if (val.length == 0) {
        PanelData defaultPanelSetting = await this._getSavedDefaultPanel(PanelUtility.getMaxPanelSize(SystemUtility.physicalSize));
        this.sqLite3Manager.insertPanel("Default Panel", jsonEncode(defaultPanelSetting.toJSON()));
        this.panelList.add(defaultPanelSetting);
      } else val.forEach((key, value) => this.panelList.add(PanelData.fromJSON(key, jsonDecode(value))));
    });
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
    this.mainPanelStream.add(panelSetting);
  }

  void insertPanel(PanelData panelSetting) {
    this.panelList.insert(0, panelSetting);
    this.updatePanel(panelSetting);
  }

  void updatePanel(PanelData panelSetting) {
    this.savePanel(panelSetting);
  }

  void savePanel(PanelData panelSetting) {
    this.sqLite3Manager.insertPanel(panelSetting.name, jsonEncode(panelSetting.toJSON()));
  }

  void removeSavedPanel(String panelName) {
    this.panelList.removeAt(this.panelList.indexWhere((val) => val.name == panelName));
    this.sqLite3Manager.removePanel(panelName);
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
  void dispose() => this.mainPanelStream.close();

}
