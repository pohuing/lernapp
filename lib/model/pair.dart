class Pair<T> {
  T one;
  T two;

  Pair(this.one, this.two);

  @override
  int get hashCode => one.hashCode ^ two.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          one == other.one &&
          two == other.two;

  Pair<T> copy() {
    return Pair(one, two);
  }

  @override
  String toString() {
    return 'Pair{one: $one, two: $two}';
  }
}
