import 'dart:math' hide log;

import 'package:collection/collection.dart';
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

extension MinMax<E extends Comparable> on List<E> {
  /// Find the smallest member in a linear search
  E min() {
    assert(isNotEmpty);
    if (length == 1) {
      return first;
    }
    int minI = 0;
    // Avoid element 0 comparing with itself
    skip(1).forEachIndexed((index, element) {
      switch (element.compareTo(this[minI])) {
        case -1:
          minI = index + 1;
          break;
        case 0:
          log(
            'Multiple equal items in this list, solution might be unpredictable',
            name: 'List.min',
          );
          break;
      }
    });

    return this[minI];
  }

  E max() {
    assert(isNotEmpty);
    if (length == 1) {
      return first;
    }
    int maxI = 0;

    // Avoid element 0 comparing with itself
    skip(1).forEachIndexed((index, element) {
      switch (element.compareTo(this[maxI])) {
        case 1:
          maxI = index + 1;
          break;
        case 0:
          log(
            'Multiple equal items in this list, solution might be unpredictable',
            name: 'List.min',
          );
          break;
      }
    });

    return this[maxI];
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
