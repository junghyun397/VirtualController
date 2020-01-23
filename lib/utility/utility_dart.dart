class Pair<A, B> {
  final A a;
  final B b;

  Pair(this.a, this.b);

  @override
  String toString() => "${a.toString()} : ${b.toString()}";
}

T getEnumFromString<T>(List<T> enumValues, String sourceString) {
  T result;
  enumValues.forEach((val) {if (val.toString() == sourceString) result = val;});
  return result;
}

void printWrapped(String text) {
  RegExp('.{1,800}').allMatches(text).forEach((match) => print(match.group(0)));
}
