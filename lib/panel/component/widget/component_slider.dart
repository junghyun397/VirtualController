import 'dart:math';

import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ComponentSlider extends Component {
  ComponentSlider(
      {Key key,
      @required componentSetting,
      @required blockWidth,
      @required blockHeight}
      ): super(key: key, componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight);

  @override
  Widget buildComponent(BuildContext context) {
    return this._buildSlider(
      context: context,

      range: this.componentSetting.getSettingsOr(ComponentSettingType.SLIDER_RANGE, 100.0),
      useIntegerRange: this.componentSetting.getSettingsOr(ComponentSettingType.SLIDER_USE_INTEGER_RANGE, true),
      unitName: this.componentSetting.getSettingsOr(ComponentSettingType.SLIDER_UNIT_NAME, ""),

      useVerticalAxis: this.componentSetting.getSettingsOr(ComponentSettingType.SLIDER_USE_VERTICAL_AXIS, true),

      useCurrentValuePopup: this.componentSetting.getSettingsOr(ComponentSettingType.SLIDER_USE_CURRENT_VALUE_POPUP, true),

      hatchMarkDensity: this.componentSetting.getSettingsOr(ComponentSettingType.SLIDER_HATCH_MARK_DENSITY, 0.4),
      hatchMarkIndexDensity: this.componentSetting.getSettingsOr(ComponentSettingType.SLIDER_HATCH_MARK_INDEX_COUNT, 9),
      useHatchMarkLabel: this.componentSetting.getSettingsOr(ComponentSettingType.SLIDER_USE_HATCH_MARK_LABEL, true),

      detentPoints: this.componentSetting.getSettingsOr(ComponentSettingType.SLIDER_DETENT_POINTS, []),
    );
  }

  Widget _buildSlider({
    @required BuildContext context,

    @required double range,
    @required bool useIntegerRange,
    @required String unitName,

    @required bool useVerticalAxis,

    @required bool useCurrentValuePopup,

    @required double hatchMarkDensity,
    @required int hatchMarkIndexDensity, // recommended 1, 4, 9
    @required bool useHatchMarkLabel,

    @required List<double> detentPoints,
  }) {
    return Selector<PanelController, double> (
      selector: (context, value) => value.inputState[this.componentSetting.targetInputs[0]] / 1000 * range,
      builder: (BuildContext context, double data, Widget _) {
        PanelController panelController = Provider.of<PanelController>(context, listen: false);
        return FlutterSlider(
          selectByTap: false,

          hatchMark: FlutterSliderHatchMark(
            distanceFromTrackBar: useVerticalAxis ? 30 : 10,
            density: hatchMarkDensity,
            smallLine: const FlutterSliderSizedBox(
              height: 8,
              width: 1,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            bigLine: const FlutterSliderSizedBox(
              height: 16,
              width: 2,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            labels: _buildSliderHatchLabel(
                range, useIntegerRange, hatchMarkIndexDensity, unitName,
                useHatchMarkLabel),
          ),

          trackBar: FlutterSliderTrackBar(
            inactiveTrackBarHeight: 8,
            activeTrackBarHeight: 8,
            inactiveTrackBar: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.black38,
                width: 2,
              ),
              color: Colors.black87,
            ),
            activeTrackBar: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.black38,
                width: 2,
              ),
              color: Colors.black87,
            ),
          ),

          touchSize: 40,
          handlerHeight: useVerticalAxis ? 30 : 50,
          handlerWidth: useVerticalAxis ? 50 : 30,
          handler: FlutterSliderHandler(
            decoration: const BoxDecoration(),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(97, 97, 97, 1),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.black54, width: 4),
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.black,
                          spreadRadius: 0.05,
                          blurRadius: 10,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                ),
                Center(
                  child: Transform.rotate(
                    angle: (useVerticalAxis ? 2 : 1) * pi / 2,
                    child: Icon(
                      Icons.menu,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          handlerAnimation: FlutterSliderHandlerAnimation(
            curve: Curves.elasticOut,
            reverseCurve: Curves.elasticOut.flipped,
            duration: Duration(milliseconds: 500),
            scale: 1.2,
          ),
          tooltip: FlutterSliderTooltip(
            disabled: !useCurrentValuePopup,
            custom: (value) => _buildSliderToolTip(value, range, useIntegerRange, unitName, detentPoints),
          ),

          axis: useVerticalAxis ? Axis.vertical : Axis.horizontal,
          rtl: useVerticalAxis,

          min: 0,
          max: range,
          step: useIntegerRange
              ? 1
              : range / 1000,
          values: [panelController.inputState[this.componentSetting.targetInputs[0]].toDouble() / 1000 * range],
          onDragStarted: (_, __, ___) => UtilitySystem.vibrate(),
          onDragging: (_, lowerValue, __) =>
            panelController.eventAnalogue(this.componentSetting.targetInputs[0], (lowerValue / range * 1000).floor().toInt()),
        );
      }
    );
  }

  List<FlutterSliderHatchMarkLabel> _buildSliderHatchLabel(double range,
      bool useIntRange, int markSightCount, String unitName,
      bool useMarkSightValue) {
    List<FlutterSliderHatchMarkLabel> result = List<
        FlutterSliderHatchMarkLabel>.generate(markSightCount, (idx) {
      double percent = (idx + 1) * 100 /
          (markSightCount + 1).floor().toDouble();
      return new FlutterSliderHatchMarkLabel(
        percent: percent,
        label: Text(
          useMarkSightValue
              ? useIntRange
              ? (percent * range / 100).floor().toString()
              : (percent * range / 100).toStringAsPrecision(2)
              : "",
          style: const TextStyle(color: Colors.white),
        ),
      );
    });

    result.insert(
        0,
        new FlutterSliderHatchMarkLabel(
          percent: 0,
          label: Text(
            useMarkSightValue ? "0" : "",
            style: const TextStyle(color: Colors.white),
          ),
        ));
    result.add(new FlutterSliderHatchMarkLabel(
      percent: 100,
      label: Text(
        useMarkSightValue
            ? useIntRange ? range.round().toString() : range.toString()
            : "",
        style: const TextStyle(color: Colors.white),
      ),
    ));

    return result;
  }

  Widget _buildSliderToolTip(double value, double range, bool useIntRange, String unitName, List<double> detentPoints) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: const [
          const BoxShadow(
            color: Colors.black54,
            spreadRadius: 0.05,
            blurRadius: 2,
            offset: const Offset(0, 0.1),
          ),
        ],
        color: this._processDetentRange(value, range, detentPoints)
            ? Colors.green.withOpacity(0.7)
            : Colors.white70,
      ),
      child: Text(
        useIntRange
            ? value.round().toString() + unitName
            : value.toStringAsFixed(2) + unitName,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  double _prvDetentPoint = 0.0;
  bool _processDetentRange(double value, double range, List<double> detentPoints) {
    double stepRange = range / 100;
    for (double detent in detentPoints) if (detent - stepRange < value) if (value < detent + stepRange) {
      if (this._prvDetentPoint != detent) {
        this._prvDetentPoint = detent;
        UtilitySystem.vibrate();
      }
      return true;
    }
    this._prvDetentPoint = 0.0;
    return false;
  }

}
