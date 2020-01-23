import 'package:VirtualFlightThrottle/panel/component/component_definition.dart';
import 'package:VirtualFlightThrottle/panel/component/widget/component.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComponentButton extends Component {
  ComponentButton(
      {Key key,
      @required componentSetting,
      @required blockWidth,
      @required blockHeight}
      ): super(key: key, componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight);

  @override
  Widget buildComponent(BuildContext context) {
    return this._buildButton(
      context: context,

      buttonLabel: this.componentSetting.getSettingsOr(ComponentSettingType.BUTTON_LABEL, ""),
    );
  }

  Widget _buildButton({
    @required BuildContext context,

    @required String buttonLabel,
  }) {
    PanelController panelController = Provider.of<PanelController>(context, listen: false);
    return ComponentButtonWidget(
      buttonLabel: buttonLabel,
      toggleValue: false,
      onForward: () => panelController.eventDigital(this.componentSetting.targetInputs[0], true),
      onReverse: () => panelController.eventDigital(this.componentSetting.targetInputs[0], false),
    );
  }
}

class ComponentButtonWidget extends StatefulWidget {
  final String buttonLabel;
  final bool toggleValue;

  final Function onForward;
  final Function onReverse;

  ComponentButtonWidget({
    Key key,
    this.buttonLabel,
    this.toggleValue,
    this.onForward,
    this.onReverse,
  }) : super(key: key);

  @override
  State<ComponentButtonWidget> createState() => _ComponentButtonWidgetState();
}

class _ComponentButtonWidgetState extends State<ComponentButtonWidget> with SingleTickerProviderStateMixin {
  static const double _size = 50.0;
  static const double _scale = 5.0;

  bool pressed = false;

  AnimationController _animationController;
  Animation<double> _animationTween;

  void _forwardButton() {
    this._animationController.forward();
    this.pressed = true;
    UtilitySystem.vibrate();
    if (widget.onForward != null) widget.onForward();
  }

  void _reverseButton() {
    this._animationController.reverse();
    this.pressed = false;
    if (widget.toggleValue) UtilitySystem.vibrate();
    if (widget.onReverse != null) widget.onReverse();
  }

  @override
  void initState() {
    super.initState();

    this._animationController = AnimationController(
      duration: const Duration(milliseconds: 40),
      vsync: this,
    );
    this._animationTween = Tween(begin: _size, end: _size - _scale).animate(this._animationController);
    this._animationController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.toggleValue && this.pressed) this._reverseButton();
        else this._forwardButton();
      },
      onTapUp: (_) {
        if (!widget.toggleValue) this._reverseButton();
      },
      child: Container(
        width: 70,
        height: 60,
        child: Center(
          child: Container(
            width: this._animationTween.value,
            height: this._animationTween.value,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(97, 97, 97, 1),
              borderRadius: BorderRadius.all(Radius.circular(this._animationTween.value / 10)),
              border: Border.all(
                color: this._animationTween.value - (_size-_scale) != 0 || !widget.toggleValue
                    ? Colors.black54
                    : Colors.black.withGreen(100),
                width: 4,
              ),
              shape: BoxShape.rectangle,
              boxShadow: [
                 BoxShadow(
                    color: Colors.black,
                    spreadRadius: 0.05,
                    blurRadius: this._animationTween.value - (_size-_scale),
                    offset: const Offset(0, 1)),
              ],
            ),
            child: Center(
              child: Text(
                widget.buttonLabel,
                style: TextStyle(
                  fontSize: this._animationTween.value / 4,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}