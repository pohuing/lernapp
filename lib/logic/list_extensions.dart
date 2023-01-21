import 'dart:math' hide log;

import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/model/pair.dart';

extension OptionalTransformations<E> on Iterable<E> {
  Iterable<E> maybeTransform(
    bool condition,
    Iterable<E> Function(Iterable<E> e) transformation,
  ) {
    if (condition) {
      return transformation(this);
    } else {
      return this;
    }
  }
}

extension RandomEntry<E> on List<E> {
  static final _randomGenerator = Random();

  /// Return a shallow copy of [this]
  List<E> copy() {
    return map((e) => e).toList();
  }

  Iterable<Pair<E>> pairwise() sync* {
    if (length % 2 != 0) {
      log(
        'List has odd number of elements, ignoring last element!',
        name: runtimeType.toString(),
      );
    }

    final numPairs = (length / 2).floor();
    for (int i = 0; i < numPairs; i++) {
      yield Pair(this[i * 2], this[i * 2 + 1]);
    }
  }

  E? random() {
    if (length == 0) {
      return null;
    }
    return this[_randomGenerator.nextInt(length)];
  }

  /// Return a shuffled copy of [this]
  List<E> shuffled() => copy()..shuffle();
}
