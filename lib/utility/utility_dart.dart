class UtilityDart {

  static T getEnumFromString<T>(List<T> enumValues, String sourceString) {
    T result;
    enumValues.forEach((val) {if (val.toString() == sourceString) result = val;});
    return result;
  }

}