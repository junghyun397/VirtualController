import 'dart:convert';

class Pair<A, B> {
  final A a;
  final B b;

  Pair(this.a, this.b);

  @override
  String toString() => "(${a.toString()}, ${b.toString()}";
}

class Tuple<A, B, C> {
  final A a;
  final B b;
  final C c;

  Tuple(this.a, this.b, this.c);

  @override
  String toString() => "(${a.toString()}, ${b.toString()}, ${c.toString()})";
}

R? runGuarded<R>(R Function() body) {
  try {
    return body.call();
  } on Exception {
    return null;
  }
}

T getEnumFromString<T>(List<T> enumValues, String sourceString) =>
  enumValues.firstWhere((val) => val.toString() == sourceString);

List<T> mixTwoList<T>(List<T> a, List<T> b) {
  final List<T> result = List.empty(growable: true);
  for (int idx = 0; idx < a.length; idx++) {
    result[idx*2] = a[idx];
    result[idx*2+1] = b[idx];
  }
  return result;
}

String trimString(String text, int length, {int dotLength = 3}) =>
  text.length > length ? "${text.substring(0, length - 3)}${utf8.decode(List.filled(dotLength, 46))}" : text;

void printWrapped(String text, {int chunk = 800}) =>
  RegExp('.{1, $chunk}').allMatches(text).forEach((match) => print(match.group(0)));
