import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/model/pair.dart';

main() {
  group('Pair tests', () {
    test('.copy different identity', () {
      final original = Pair(1, 2);

      final copy = original.copy();

      expect(copy, isNot(same(original)));
    });

    test('.copy equals', () {
      final original = Pair(1, 2);

      final copy = original.copy();

      expect(copy, original);
    });

    test('.copy hash', () {
      final original = Pair(1, 2);

      final copy = original.copy();

      expect(copy.hashCode, original.hashCode);
    });
  });
}
