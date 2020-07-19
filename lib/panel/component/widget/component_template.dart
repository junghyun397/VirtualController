import 'package:VirtualFlightThrottle/panel/component/widget/component.dart';
import 'package:VirtualFlightThrottle/panel/panel_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/*
1. Add component-setting-type in enum ComponentSettingType
2. Add component-setting-definition in map COMPONENT_SETTING_DEFINITION
3. Add component-type in enum ComponentType
4. Add component-definition in map COMPONENT_DEFINITION
5. Success!
*/

class ComponentTemplate extends Component {
  ComponentTemplate({
    Key key,
    @required componentSetting,
    @required blockWidth,
    @required blockHeight,
  }) : super(key: key, componentSetting: componentSetting, blockWidth: blockWidth, blockHeight: blockHeight);

  @override
  Widget buildComponent(BuildContext context) {
    return this._buildTemplate(
      context: context,
    );
  }

  @override
  Widget _buildTemplate({
    @required BuildContext context,
  }) {
    PanelController panelController = Provider.of<PanelController>(context, listen: false);

    return Container();
  }

}