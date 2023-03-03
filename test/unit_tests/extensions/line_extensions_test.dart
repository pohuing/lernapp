import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/logic/list_extensions.dart';
import 'package:lernapp/model/pair.dart';

main() {
  group('line extensions', () {
    test('.copy', () {
      final original = [1, 2, 3];

      final copy = original.copy();

      expect(copy, isNot(same(original)));
      expect(copy, equals(original));
    });

    test('.pairwise even numbered', () {
      final list = [1, 2, 3, 4, 5, 6];

      final it = list.pairwise();

      expect(it, [
        Pair(1, 2),
        Pair(3, 4),
        Pair(5, 6),
      ]);
    });

    test('.pairwise odd numbered', () {
      final list = [1, 2, 3, 4, 5];

      final it = list.pairwise();

      expect(it, [Pair(1, 2), Pair(3, 4)]);
    });

    test('.random', () {
      final list = [1, 2, 3, 4, 5];

      for (int i = 0; i < 100; i++) {
        expect(list.random(), isIn(list));
      }
    });

    test('.random empty list', () {
      final list = [];

      expect(list.random(), isNull);
    });

    group('.min', () {
      test('.min', () {
        final list = [2, 1, -1, -3];

        expect(list.min(), -3);
      });

      test('.min empty list', () {
        expect(<int>[].min, throwsAssertionError);
      });

      test('.min one element', () {
        expect([1].min(), 1);
      });
    });

    group('max', () {
      test('.max', () {
        final list = [1, 2, -1, -3];

        expect(list.max(), 2);
      });

      test('.min empty list', () {
        expect(<int>[].max, throwsAssertionError);
      });

      test('.min one element', () {
        expect([1].max(), 1);
      });
    });
  });
}
