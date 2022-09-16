import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/model/line.dart';

void main() {
  test('Test line pruning', () {
    final line = Line(
      [
        const Offset(0, 0),
        const Offset(1, 0),
        const Offset(2, 0),
      ],
      null,
    );

    line.prune();

    expect(line.path.length, 2);
  });

  test('Test line segment hit test', () {
    expect(
      Line.segmentInCircle(
        const Offset(-2, 0),
        const Offset(2, 0),
        const Offset(0, 1),
        1,
      ),
      false,
    );
    expect(
      Line.segmentInCircle(
        const Offset(-2, 0),
        const Offset(2, 0),
        const Offset(0, 1),
        0.5,
      ),
      false,
    );
    expect(
      Line.segmentInCircle(
        const Offset(-2, 0),
        const Offset(2, 0),
        const Offset(0, 1),
        2,
      ),
      true,
    );
  });

  test('Test line hit test', () {
    final line = Line(
      [
        const Offset(-2, 0),
        const Offset(0, 2),
        const Offset(2, 0),
      ],
      null,
    );

    expect(
      line.isInCircle(const Offset(0, 0), 1),
      false,
      reason: 'Found line',
    );
    expect(
      line.isInCircle(const Offset(0, 0), 1.5),
      true,
      reason: 'Failed to find line',
    );
    expect(
      line.isInCircle(const Offset(-4, -2), 2),
      false,
      reason: 'Circle matches infinite line',
    );
  });
}
