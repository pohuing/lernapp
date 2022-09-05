import 'dart:math';

extension RandomEntry<E> on List<E> {
  static final _randomGenerator = Random();

  E? random() {
    if (length == 0) {
      return null;
    }
    return this[_randomGenerator.nextInt(length)];
  }
}
