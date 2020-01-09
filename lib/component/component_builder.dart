import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class ComponentBuilder {

  static Widget wrapByName(Widget widget, String name) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          widget,
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              name.toUpperCase(),
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  // Button

  static Widget buildButton() {return Container();}

  static Widget buildToggleButton() {return Container();}

  static Widget buildSwitch() {return Container();}

  // Slider

  static Widget buildSlider({
    @required BuildContext context,
    
    @required String name,
    String unitName = "",
    
    @required double range,
    bool useIntRange = false,
    
    @required Axis axis,

    bool useValuePopup = false,
    
    double markDensity = 0.4,
    int markSightCount = 9, // recommended 1, 4, 9
    bool useMarkSightValue = true,
    
    List<double> detentPoints = const [],
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 60,
            height: MediaQuery.of(context).size.height - 60,
            child: FlutterSlider(

              selectByTap: false,
              rtl: true,

              hatchMark: FlutterSliderHatchMark(
                distanceFromTrackBar: 9,
                density: markDensity,
                smallLine: const FlutterSliderSizedBox(
                  height: 15,
                  width: 2,
                  decoration: BoxDecoration(color: Colors.white),
                ),
                bigLine: const FlutterSliderSizedBox(
                  height: 25,
                  width: 3,
                  decoration: BoxDecoration(color: Colors.white),
                ),
                labels: _buildSliderHatchLabel(range, useIntRange, markSightCount, unitName, useMarkSightValue),
              ),

              trackBar: const FlutterSliderTrackBar(
                inactiveTrackBarHeight: 3,
                activeTrackBarHeight: 3,
                inactiveTrackBar: BoxDecoration(
                  color: Colors.white,
                ),
                activeTrackBar: BoxDecoration(
                  color: Colors.white,
                ),
              ),

              handlerHeight: 10,
              handlerWidth: 25,
              handler: FlutterSliderHandler(
                decoration: const BoxDecoration(),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.black,
                          spreadRadius: 0.05,
                          blurRadius: 5,
                          offset: Offset(0, 1)
                      ),
                    ],
                  ),
                ),
              ),
              handlerAnimation: FlutterSliderHandlerAnimation(
                  curve: Curves.elasticOut,
                  reverseCurve: Curves.elasticOut.flipped,
                  duration: Duration(milliseconds: 500),
                  scale: 1.4,
              ),

              touchSize: 30,
              tooltip: FlutterSliderTooltip(
                disabled: useValuePopup,
                rightSuffix: Text(unitName, style: TextStyle(fontSize: 10),),
                boxStyle: FlutterSliderTooltipBox(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.05,
                            blurRadius: 5,
                            offset: Offset(0, 1)),
                      ],
                      color: Colors.white70),
                ),
                textStyle: const TextStyle(fontSize: 10, color: Colors.black87),
              ),

              axis: axis,

              min: 0,
              max: range,
              step: useIntRange ? 1 : range / 1000,
              values: [0],

              onDragging: (handlerIndex, lowerValue, _) {},
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                name.toUpperCase(),
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<FlutterSliderHatchMarkLabel> _buildSliderHatchLabel(double range, bool isIntRange, int markSightCount, String unitName, bool useMarkSightValue) {
    List<FlutterSliderHatchMarkLabel> result = List<FlutterSliderHatchMarkLabel>.generate(markSightCount, (idx) {
      double percent = (idx + 1) * 100 / (markSightCount + 1).floor().toDouble();
      return new FlutterSliderHatchMarkLabel(
        percent: percent,
        label: Text(
          useMarkSightValue ? isIntRange ? (percent*range/100).floor().toString() : (percent*range/100).toStringAsPrecision(3) : "",
          style: const TextStyle(color: Colors.white),
        ),
      );
    });

    result.insert(0, new FlutterSliderHatchMarkLabel(
      percent: 0,
      label: Text(
        useMarkSightValue? "0"+unitName : "",
        style: const TextStyle(color: Colors.white),
      ),
    ));
    result.add(new FlutterSliderHatchMarkLabel(
      percent: 100,
      label: Text(
        useMarkSightValue ? isIntRange ? range.round().toString()+unitName : range.toString()+unitName : "",
        style: const TextStyle(color: Colors.white),
      ),
    ));

    return result;
  }

}