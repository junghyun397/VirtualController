import 'dart:math';

import 'package:vfcs/panel/component/widgets/component.dart';
import 'package:vfcs/panel/panel_controller.dart';
import 'package:vfcs/utility/utility_system.dart';
import 'package:vfcs/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComponentToggleSwitch extends Component {
  ComponentToggleSwitch(
      {Key key,
      @required componentSetting,
      @required blockWidth,
      @required blockHeight}
      ): super(key: key, componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight);

  @override
  Widget buildComponent(BuildContext context) {
    return this._buildSwitch(
      context: context,
    );
  }

  Widget _buildSwitch({
    @required BuildContext context,

  }) {
    PanelController panelController = Provider.of<PanelController>(context, listen: false);
    return ComponentToggleSwitchWidget(
      height: min(this.blockHeight * this.componentSetting.height, 120),

      onForwardTop: () => panelController.eventDigital(this.componentSetting.targetInputs[0], true),
      onReverseTop: () => panelController.eventDigital(this.componentSetting.targetInputs[0], false),

      onForwardBottom: () => panelController.eventDigital(this.componentSetting.targetInputs[1], true),
      onReverseBottom: () => panelController.eventDigital(this.componentSetting.targetInputs[1], false),
    );
  }
}

class ComponentToggleSwitchWidget extends StatefulWidget {
  final double handleSize;
  final double width;
  final double height;

  final Function onForwardTop;
  final Function onReverseTop;

  final Function onForwardBottom;
  final Function onReverseBottom;

  ComponentToggleSwitchWidget({
    Key key,
    this.handleSize = 30,
    this.width = PanelUtility.MIN_BLOCK_WIDTH,
    this.height,
    this.onForwardTop,
    this.onReverseTop,
    this.onForwardBottom,
    this.onReverseBottom,
  }) : super(key: key);

  @override
  State<ComponentToggleSwitchWidget> createState() => _ComponentToggleSwitchWidgetState();
}

class _ComponentToggleSwitchWidgetState extends State<ComponentToggleSwitchWidget> with SingleTickerProviderStateMixin {
  double heightOffset;

  bool onDragging = false;
  double dragSummary = 0;

  bool nowPosition;

  AnimationController _animationController;
  Animation<double> _animationTween;

  @override
  void initState() {
    super.initState();

    this.heightOffset = (widget.height / 2) - widget.handleSize;

    this._animationController = AnimationController(
      duration: Duration(milliseconds: 50),
      vsync: this,
    );
    this._animationTween = Tween(begin: 0.0, end: this.heightOffset).animate(this._animationController);
    this._animationController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (_) => this.onDragging = true,
      onVerticalDragUpdate: (val) => this.dragSummary += val.delta.dy,
      onVerticalDragEnd: (val) {
        if (!(-0.5 < this.dragSummary && this.dragSummary < 0.5)) {
          bool forwardTop = this.dragSummary < 0;
          if (this.nowPosition == null && forwardTop) this._forwardTop();
          else if (this.nowPosition == null && !forwardTop) this._forwardBottom();
          else if (this.nowPosition && !forwardTop) this._reverseTop();
          else if (!this.nowPosition && forwardTop) this._reverseBottom();
        }
        this.onDragging = false;
        this.dragSummary = 0;
      },

      child: Container(
        color: Colors.transparent,
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: (widget.width / 2) - 4,
              bottom: 5,
              child: Container(
                width: 8,
                height: widget.height - 32 - 10,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Colors.black38,
                    width: 2,
                  ),
                  color: Colors.black87,
                ),
              ),
            ),
            Positioned(
              left: (widget.width / 2) - (widget.handleSize / 2),
              bottom: this.nowPosition == null
                  ? this.heightOffset
                  : this.nowPosition
                  ? this._animationTween.value + this.heightOffset - 2
                  : this.heightOffset - this._animationTween.value,
              child: Container(
                width: widget.handleSize,
                height: widget.handleSize,
                decoration: BoxDecoration(
                  color: componentColor,
                  borderRadius: BorderRadius.all(Radius.circular(widget.handleSize)),
                  border: Border.all(color: componentBorderColor, width: 5),
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black,
                        spreadRadius: 0.05,
                        blurRadius: 5,
                        offset: const Offset(0, 2)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _forwardTop() {
    this.nowPosition = true;
    SystemUtility.vibrate();
    this._animationController.forward();
    widget.onForwardTop();
  }

  void _reverseTop() {
    this.nowPosition = null;
    SystemUtility.vibrate();
    this._animationController.reverse();
    widget.onReverseTop();
  }

  void _forwardBottom() {
    this.nowPosition = false;
    SystemUtility.vibrate();
    this._animationController.forward();
    widget.onForwardBottom();
  }

  void _reverseBottom() {
    this.nowPosition = null;
    SystemUtility.vibrate();
    this._animationController.reverse();
    widget.onReverseBottom();
  }

}
