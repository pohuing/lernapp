import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/model/color_pair.dart';

void main() {
  group('ColorPair tests', () {
    test('toMap serialization', () {
      const original = ColorPair(
        brightTheme: Color.fromARGB(1, 2, 3, 4),
        darkTheme: Color.fromARGB(9, 8, 7, 6),
      );

      final converted = original.toMap();

      expect(
        converted[ColorPair.brightThemeKey],
        original.brightTheme.value,
        reason: 'Incorrect brightTheme: ${converted.toString()}',
      );
      expect(
        converted[ColorPair.darkThemeKey],
        original.darkTheme.value,
        reason: 'Incorrect darkTheme: ${converted.toString()}',
      );
    });

    test('fromMap succeed', () {
      const brightTheme = Color.fromARGB(1, 2, 3, 4);
      const darkTheme = Color.fromARGB(9, 8, 7, 6);
      final map = {
        ColorPair.brightThemeKey: brightTheme.value,
        ColorPair.darkThemeKey: darkTheme.value,
      };

      final converted = ColorPair.fromMap(map);

      expect(
        converted!.brightTheme,
        brightTheme,
        reason: 'Incorrect brightTheme: ${converted.toString()}',
      );
      expect(
        converted.darkTheme,
        darkTheme,
        reason: 'Incorrect darkTheme: ${converted.toString()}',
      );
    });

    test('fromMap fail missing brightTheme', () {
      const darkTheme = Color.fromARGB(9, 8, 7, 6);
      final map = {
        ColorPair.brightThemeKey: null,
        ColorPair.darkThemeKey: darkTheme.value,
      };

      final converted = ColorPair.fromMap(map);
      expect(
        converted,
        null,
        reason: 'fromMap should fail when brightTheme is missing',
      );
    });

    test('fromMap fail missing darkTheme', () {
      const brightTheme = Color.fromARGB(1, 2, 3, 4);
      final map = {
        ColorPair.brightThemeKey: brightTheme,
        ColorPair.darkThemeKey: null,
      };

      final converted = ColorPair.fromMap(map);
      expect(
        converted,
        null,
        reason: 'fromMap should fail when darkTheme is missing',
      );
    });

    test('Back and forth', () {
      const original = ColorPair(
        brightTheme: Color.fromARGB(1, 2, 3, 4),
        darkTheme: Color.fromARGB(9, 8, 7, 6),
      );

      final serialized = original.toMap();
      final deserialized = ColorPair.fromMap(serialized);
      expect(
        deserialized,
        original,
        reason:
            'original and serialized are not equal\n\t original:${original.toString()}, \n\t serialized: $serialized, \n\t deserialized: ${deserialized.toString()}',
      );
    });
  });
}
