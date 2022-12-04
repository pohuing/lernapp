import 'package:flutter/material.dart';
import 'package:lernapp/logic/logging.dart';

/// A pair of colours used for drawing on a canvas with colors fitting to the
/// current system theme
class ColorPair {
  /// Color to be used when using the bright theme
  final Color brightTheme;

  /// Color to be use when using the dark theme
  final Color darkTheme;

  static const brightThemeKey = 'brightTheme';
  static const darkThemeKey = 'darkTheme';

  const ColorPair({required this.brightTheme, required this.darkTheme});

  const ColorPair.defaultColors()
      : darkTheme = Colors.white,
        brightTheme = Colors.black;

  @override
  int get hashCode => brightTheme.hashCode ^ darkTheme.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorPair &&
          runtimeType == other.runtimeType &&
          brightTheme == other.brightTheme &&
          darkTheme == other.darkTheme;

  /// Creates a deep copy of this color pair
  ColorPair copy() {
    return ColorPair(
      brightTheme: Color(brightTheme.value),
      darkTheme: Color(darkTheme.value),
    );
  }

  @override
  String toString() {
    return 'ColorPair{brightTheme: $brightTheme, darkTheme: $darkTheme}';
  }

  static ColorPair? fromMap(Map map) {
    try {
      final brightTheme = Color(map['brightTheme'] as int);
      final darkTheme = Color(map['darkTheme'] as int);
      return ColorPair(brightTheme: brightTheme, darkTheme: darkTheme);
    } catch (e) {
      log(
        'Failed to create ColorPair, ${e.toString()}',
        name: 'ColorPair.fromMap()',
      );
    }
    return null;
  }

  Map<String, int> toMap() {
    return {
      brightThemeKey: brightTheme.value,
      darkThemeKey: darkTheme.value,
    };
  }
}
