import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/model/bounding_box.dart';
import 'package:lernapp/model/color_pair.dart';
import 'package:lernapp/model/line.dart';

main() {
  group('Test bounding boxes', () {
    test('creation .fromAB', () {
      const a = Offset(-3, 3);
      const b = Offset(3, -3);
      final box = BoundingBox.fromAB(a, b);

      expect(box.topRight.dx, 3);
      expect(box.topRight.dy, 3);
      expect(box.bottomLeft.dx, -3);
      expect(box.bottomLeft.dy, -3);
    });

    test('creation .fromLine', () {
      final line = Line(
        [
          const Offset(-3, 3),
          const Offset(3, -3),
        ],
        ColorPair.defaultColors,
        1,
      );

      final box = BoundingBox.fromLine(line);

      expect(box.topRight.dx, 3.5);
      expect(box.topRight.dy, 3.5);
      expect(box.bottomLeft.dx, -3.5);
      expect(box.bottomLeft.dy, -3.5);
    });

    test('contains', () {
      final line = Line(
        [
          const Offset(-3, 3),
          const Offset(3, -3),
        ],
        ColorPair.defaultColors,
        1,
      );

      final box = BoundingBox.fromLine(line);

      expect(box.approxContains(Offset.zero), true);
      expect(box.approxContains(const Offset(4, 4)), false);
      expect(box.approxContains(const Offset(4, 4), 1), true);
    });

    test('creation should fail', () {
      expect(
        () => BoundingBox.checked(
          topRight: Offset.zero,
          bottomLeft: const Offset(3.5, -3.5),
        ),
        throwsAssertionError,
      );

      expect(
        () => BoundingBox.checked(
          topRight: Offset.zero,
          bottomLeft: const Offset(-3.5, 3.5),
        ),
        throwsAssertionError,
      );
    });
  });
}
