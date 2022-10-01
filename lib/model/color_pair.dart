import 'dart:ui';

/// A pair of colours used for drawing on a canvas with colors fitting to the
/// current system theme
class ColorPair {
  /// Color to be used when using the bright theme
  final Color brightTheme;

  /// Color to be use when using the dark theme
  final Color darkTheme;

  const ColorPair({required this.brightTheme, required this.darkTheme});

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
}
