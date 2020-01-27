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

List<T> mixTwoList<T>(List<T> a, List<T> b) {
  List<T> result = List<T>(a.length+b.length);
  for (int idx = 0; idx < a.length; idx++) {
    result[idx*2] = a[idx];
    result[idx*2+1] = b[idx];
  }
  return result;
}

void printWrapped(String text, {int chunk = 800}) {
  RegExp('.{1, $chunk}').allMatches(text).forEach((match) => print(match.group(0)));
}
