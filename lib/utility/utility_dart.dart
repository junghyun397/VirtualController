class Pair<A, B> {
  final A a;
  final B b;

  Pair(this.a, this.b);

  @override
  String toString() {
    return "${a.toString()} : ${b.toString()}";
  }
}

T getEnumFromString<T>(List<T> enumValues, String sourceString) {
  T result;
  enumValues.forEach((val) {if (val.toString() == sourceString) result = val;});
  return result;
}
