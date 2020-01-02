class ControllerComponent<T> {
  T value;
  T defaultValue;

  T minValue, maxValue;

  String controllerName;
  String description;

  SettingPiece({
    T defaultValue,
    String controllerName,
    String description,
  }) {
    this.value = defaultValue;
    this.defaultValue = defaultValue;

    this.controllerName = controllerName;
    this.description = description;
  }
}