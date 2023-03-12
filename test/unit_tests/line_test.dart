import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/logic/list_extensions.dart';
import 'package:lernapp/model/color_pair.dart';
import 'package:lernapp/model/line.dart';
import 'package:lernapp/model/line_type.dart';

void main() {
  group('Line Tests', () {
    test('Test line pruning', () {
      final line = Line(
        [
          Offset.zero,
          const Offset(1, 0),
          const Offset(2, 0),
        ],
        ColorPair.defaultColors,
        1,
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
          0.5,
        ),
        true,
      );
      expect(
        Line.segmentInCircle(
          const Offset(-2, 0),
          const Offset(2, 0),
          const Offset(0, 3),
          1,
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
          0.5,
        ),
        false,
      );
      expect(
        Line.segmentInCircle(
          const Offset(-2, 0),
          const Offset(2, 0),
          const Offset(-3, 0),
          1,
          0.5,
        ),
        true,
        reason: 'Eraser should touch edge of p1',
      );
      expect(
        Line.segmentInCircle(
          const Offset(-2, 0),
          const Offset(2, 0),
          const Offset(3, 0),
          1,
          0.5,
        ),
        true,
        reason: 'Eraser should touch edge of p2',
      );
      expect(
        Line.segmentInCircle(
          const Offset(-2, 0),
          const Offset(2, 0),
          const Offset(-4, 0),
          1,
          0.5,
        ),
        false,
        reason: 'Eraser should miss edge of p2',
      );
    });

    test('Test line hit test', () {
      final line = Line(
        [
          const Offset(-2, 0),
          const Offset(0, 2),
          const Offset(2, 0),
        ],
        ColorPair.defaultColors,
        1,
      );

      expect(
        line.isInCircle(Offset.zero, 0.5),
        false,
        reason: 'Found line',
      );
      expect(
        line.isInCircle(Offset.zero, 1.5),
        true,
        reason: 'Failed to find line',
      );
      expect(
        line.isInCircle(const Offset(-10, -8), 2),
        false,
        reason: 'Circle matches infinite line',
      );
    });

    test(
      'Test dot hit test',
      () {
        final line = Line(
          [Offset.zero],
          ColorPair.defaultColors,
          1,
        );

        expect(
          line.isInCircle(Offset.zero, 1),
          true,
          reason: 'Line with one segment is not in circle',
        );
        expect(
          line.isInCircle(const Offset(1, 0), 1),
          true,
          reason: 'Line with one segment does not touch circle',
        );
        expect(
          line.isInCircle(const Offset(2, 0), 1),
          false,
          reason: 'Line with one segment is in circle',
        );
      },
    );

    test('toMap serialization', () {
      final original = Line(
        [Offset.zero, const Offset(1, 1), const Offset(2, 0)],
        const ColorPair(
          brightTheme: Color.fromARGB(1, 2, 3, 4),
          darkTheme: Color.fromARGB(9, 8, 7, 6),
        ),
        1,
      );

      final converted = original.toMap();
      expect(
        converted[Line.colorsKey][ColorPair.brightThemeKey],
        original.colors.brightTheme.value,
        reason:
            'brightTheme mismatch, original: $original, brightTheme: ${converted[ColorPair.brightThemeKey]}',
      );
      expect(
        converted[Line.colorsKey][ColorPair.darkThemeKey],
        original.colors.darkTheme.value,
        reason:
            'darkTheme mismatch, original: $original, darkTheme: ${converted[ColorPair.darkThemeKey]}',
      );

      expect(
        converted[Line.sizeKey],
        original.size,
        reason:
            'Size mismatch, original: ${original.size}, serialized: ${converted[Line.sizeKey]}',
      );

      expect(
        converted[Line.pathKey],
        <double>[0, 0, 1, 1, 2, 0],
        reason:
            'Path mismatch, original: ${original.path}, serialized: ${converted[Line.pathKey]}',
      );
    });

    test('fromMap deserialization', () {
      var originalPath = <double>[1, 1, 2, 2, 2, 0];
      var originalSize = 1;
      const originalColors = ColorPair(
        brightTheme: Color.fromARGB(1, 2, 3, 4),
        darkTheme: Color.fromARGB(0, 9, 8, 7),
      );
      final original = {
        Line.pathKey: originalPath,
        Line.colorsKey: originalColors.toMap(),
        Line.sizeKey: originalSize,
        Line.typeKey: LineType.correction.index,
      };

      final deserialized = Line.fromMap(original)!;

      expect(
        deserialized.size,
        originalSize,
        reason:
            'Size mismatch, original $originalSize, deserialized ${deserialized.size}',
      );

      expect(
        deserialized.colors,
        originalColors,
        reason:
            'Colors mismatch, original $originalColors, deserialized: ${deserialized.colors}',
      );

      originalPath.pairwise().forEachIndexed((index, element) {
        expect(
          deserialized.path[index],
          Offset(element.one, element.two),
          reason:
              'Path mismatch at index $index, original: $originalPath, deserialized: ${deserialized.path}',
        );
      });
    });

    test('back and forth', () {
      final original = Line(
        const [
          Offset(1, 1),
          Offset(2, 2),
          Offset(-1, 0),
        ],
        const ColorPair(
          brightTheme: Color.fromARGB(1, 2, 3, 4),
          darkTheme: Color.fromARGB(9, 8, 7, 6),
        ),
        1.1,
      );

      final serialized = original.toMap();
      final deserialized = Line.fromMap(serialized)!;

      expect(deserialized, original);
    });
  });
}
