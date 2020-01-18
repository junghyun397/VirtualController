import 'dart:math';

import 'package:VirtualFlightThrottle/panel/component/widget/component.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';

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

      range: this.componentSetting.getSettingsOr("range", 100.0),
      useIntRange: this.componentSetting.getSettingsOr("use-int-range", true),
      unitName: this.componentSetting.getSettingsOr("unit-name", ""),

      axis: this.componentSetting.getSettingsOr("axis", true),

      useValuePopup: this.componentSetting.getSettingsOr("use-value-popup", true),

      markDensity: this.componentSetting.getSettingsOr("mark-density", 0.4),
      markSightCount: this.componentSetting.getSettingsOr("mark-sight-count", 9),
      useMarkSightValue: this.componentSetting.getSettingsOr("use-mark-sight-value", true),

      detentPoints: this.componentSetting.getSettingsOr("detent-points", []),
    );
  }

  Widget _buildSlider({
    @required BuildContext context,

    @required double range,
    @required bool useIntRange,
    @required String unitName,

    @required bool axis,

    @required bool useValuePopup,

    @required double markDensity,
    @required int markSightCount, // recommended 1, 4, 9
    @required bool useMarkSightValue,

    @required List<double> detentPoints,
  }) {
    return Consumer<PanelController> (
      builder: (BuildContext context, PanelController panelController, Widget _) {
        return FlutterSlider(
          selectByTap: false,

          hatchMark: FlutterSliderHatchMark(
            distanceFromTrackBar: axis ? 30 : 10,
            density: markDensity,
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
                range, useIntRange, markSightCount, unitName,
                useMarkSightValue),
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
          handlerHeight: axis ? 30 : 50,
          handlerWidth: axis ? 50 : 30,
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
                    angle: (axis ? 2 : 1) * pi / 2,
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
            disabled: !useValuePopup,
            custom: (value) => _buildSliderToolTip(value, useIntRange, unitName),
          ),

          axis: axis ? Axis.vertical : Axis.horizontal,
          rtl: axis,

          min: 0,
          max: range,
          step: useIntRange
              ? 1
              : range / 1000,
          values: [0],

          onDragging: (handlerIndex, lowerValue, _) =>
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

  Widget _buildSliderToolTip(double value, bool useIntRange, String unitName) {
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
        color: Colors.white70,
      ),
      child: Text(
        useIntRange
            ? value.round().toString() + unitName
            : value.toStringAsFixed(2) + unitName,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

}
