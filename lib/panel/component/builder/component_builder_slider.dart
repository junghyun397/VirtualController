import 'dart:math';

import 'package:VirtualFlightThrottle/panel/component/component_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import 'package:VirtualFlightThrottle/panel/component/builder/component_builder.dart';

class ComponentBuilderSlider extends ComponentBuilder {
  ComponentBuilderSlider(double blockWidth, double blockHeight) : super(blockWidth, blockHeight);


  @override
  Widget buildComponentWidget(ComponentSetting componentSetting) {
    return Container();
  }

  Widget wrapByName(Widget widget, String name) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          widget,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
  // Slider

  Widget buildSlider({
    @required height,

    @required BuildContext context,

    @required String name,

    @required double range,
    bool useIntRange = false,
    String unitName = "",

    @required Axis axis,

    bool useValuePopup = false,

    double markDensity = 0.4,
    int markSightCount = 9, // recommended 1, 4, 9
    bool useMarkSightValue = true,

    List<double> detentPoints = const [],
  }) {
    name = name.substring(0, min(name.length, 5)).toUpperCase();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: this.blockWidth,
            height: height,
            child: FlutterSlider(

              selectByTap: false,
              rtl: true,

              hatchMark: FlutterSliderHatchMark(
                distanceFromTrackBar: 30,
                density: markDensity,
                smallLine: const FlutterSliderSizedBox(
                  height: 8,
                  width: 1,
                  decoration: BoxDecoration(color: Colors.white),
                ),
                bigLine: const FlutterSliderSizedBox(
                  height: 16,
                  width: 2,
                  decoration: BoxDecoration(color: Colors.white),
                ),
                labels: _buildSliderHatchLabel(range, useIntRange, markSightCount, unitName, useMarkSightValue),
              ),

              trackBar: FlutterSliderTrackBar(
                inactiveTrackBarHeight: 8,
                activeTrackBarHeight: 8,
                inactiveTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Colors.black38,
                    width: 2,
                  ),
                  color: Colors.black87,
                ),
                activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Colors.black38,
                    width: 2,
                  ),
                  color: Colors.black87,
                ),
              ),

              handlerHeight: 30,
              handlerWidth: 50,
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
                              offset: Offset(0, 2)
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Icon(
                        Icons.menu,
                        color: Colors.white70,
                        size: 20,
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

              touchSize: 40,
              tooltip: FlutterSliderTooltip(
                custom: (value) => _buildSliderToolTip(value, useIntRange, unitName),
              ),

              axis: axis,

              min: 0,
              max: range,
              step: useIntRange ? 1 : range / 1000,
              values: [0],

              onDragging: (handlerIndex, lowerValue, _) {
              },
            ),
          ),
        ],
      ),
    );
  }

  List<FlutterSliderHatchMarkLabel> _buildSliderHatchLabel(double range, bool useIntRange, int markSightCount, String unitName, bool useMarkSightValue) {
    List<FlutterSliderHatchMarkLabel> result = List<FlutterSliderHatchMarkLabel>.generate(markSightCount, (idx) {
      double percent = (idx + 1) * 100 / (markSightCount + 1).floor().toDouble();
      return new FlutterSliderHatchMarkLabel(
        percent: percent,
        label: Text(
          useMarkSightValue ? useIntRange ? (percent*range/100).floor().toString() : (percent*range/100).toStringAsPrecision(2) : "",
          style: const TextStyle(color: Colors.white),
        ),
      );
    });

    result.insert(0, new FlutterSliderHatchMarkLabel(
      percent: 0,
      label: Text(
        useMarkSightValue? "0" : "",
        style: const TextStyle(color: Colors.white),
      ),
    ));
    result.add(new FlutterSliderHatchMarkLabel(
      percent: 100,
      label: Text(
        useMarkSightValue ? useIntRange ? range.round().toString() : range.toString() : "",
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
            offset: Offset(0, 0.1),
          ),
        ],
        color: Colors.white70,
      ),
      child: Text(
        useIntRange ? value.round().toString()+unitName : value.toStringAsFixed(2)+unitName,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}