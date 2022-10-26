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
    late final int a;
    if (length % 2 != 0) {
      log(
        'List has odd number of elements, ignoring last element!',
        name: runtimeType.toString(),
      );
      a = (length / 2).floor();
    } else {
      a = (length / 2).floor();
    }
    for (int i = 0; i < a; i++) {
      yield Pair(this[i * 2], this[i * 2 + 1]);
    }
  }
}
