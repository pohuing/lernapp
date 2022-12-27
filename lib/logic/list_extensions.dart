import 'dart:math' hide log;

import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/model/pair.dart';

extension RandomEntry<E> on List<E> {
  static final _randomGenerator = Random();

  E? random() {
    if (length == 0) {
      return null;
    }
    return this[_randomGenerator.nextInt(length)];
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

  List<E> copy() {
    return map((e) => e).toList();
  }
}
