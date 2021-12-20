import 'package:vfcs/panel/component/component_definition.dart';
import 'package:vfcs/panel/component/widgets/component.dart';
import 'package:vfcs/panel/panel_controller.dart';
import 'package:vfcs/utility/utility_system.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComponentButtonThemeData extends ComponentThemeData {

}

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
    PanelController controller = Provider.of<PanelController>(context, listen: false);
    return ComponentButtonWidget(
      width: this.componentSetting.width * 50.0,
      height: this.componentSetting.height * 50.0,
      buttonLabel: buttonLabel,
      toggleValue: false,
      onForward: () => controller.eventDigital(this.componentSetting.targetInputs[0], true),
      onReverse: () => controller.eventDigital(this.componentSetting.targetInputs[0], false),
    );
  }
}

class ComponentButtonWidget extends StatefulWidget {
  final double width;
  final double height;

  final String buttonLabel;
  final bool toggleValue;

  final Function onForward;
  final Function onReverse;

  ComponentButtonWidget({
    Key key,
    @required this.width,
    @required this.height,
    @required this.buttonLabel,
    @required this.toggleValue,
    @required this.onForward,
    @required this.onReverse,
  }) : super(key: key);

  @override
  State<ComponentButtonWidget> createState() => _ComponentButtonWidgetState();
}

class _ComponentButtonWidgetState extends State<ComponentButtonWidget> with SingleTickerProviderStateMixin {
  static const double _scale = 5.0;

  bool pressed = false;

  AnimationController _animationController;
  Animation<double> _animationTween;

  void _forwardButton() {
    this._animationController.forward();
    this.pressed = true;
    SystemUtility.vibrate();
    if (widget.onForward != null) widget.onForward();
  }

  void _reverseButton() {
    this._animationController.reverse();
    this.pressed = false;
    if (widget.toggleValue) SystemUtility.vibrate();
    if (widget.onReverse != null) widget.onReverse();
  }

  @override
  void initState() {
    super.initState();

    this._animationController = AnimationController(
      duration: const Duration(milliseconds: 40),
      vsync: this,
    );
    this._animationTween = Tween(begin: 0.0, end: _scale).animate(this._animationController);
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
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Container(
            width: widget.width - this._animationTween.value,
            height: widget.height - this._animationTween.value,
            decoration: BoxDecoration(
              color: componentColor,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: this._animationTween.value == 0 || !widget.toggleValue
                    ? componentBorderColor
                    : Colors.black.withGreen(100),
                width: 4,
              ),
              shape: BoxShape.rectangle,
              boxShadow: [
                 BoxShadow(
                    color: Colors.black,
                    spreadRadius: 0.05,
                    blurRadius: _scale - this._animationTween.value,
                    offset: const Offset(0, 1)),
              ],
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  widget.buttonLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}