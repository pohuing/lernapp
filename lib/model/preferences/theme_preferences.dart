import 'package:lernapp/model/color_pair.dart';

class ThemePreferences {
  static const String paintAAKey = 'paintAA';
  static const String blendAAKey = 'blendAA';
  static const String correctionColorsKey = 'correctionColors';

  final bool paintAA;
  final bool blendAA;
  final ColorPair correctionColors;

  ThemePreferences(this.paintAA, this.blendAA, ColorPair? correctionColors)
      : correctionColors = correctionColors ?? ColorPair.correctionColors;

  ThemePreferences.defaults()
      : paintAA = false,
        blendAA = false,
        correctionColors = ColorPair.correctionColors;

  ThemePreferences copyWith({
    bool? paintAA,
    bool? blendAA,
    ColorPair? correctionColors,
  }) {
    return ThemePreferences(
      paintAA ?? this.paintAA,
      blendAA ?? this.blendAA,
      correctionColors ?? this.correctionColors,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      paintAAKey: paintAA,
      blendAAKey: blendAA,
      correctionColorsKey: correctionColors.toMap(),
    };
  }

  static ThemePreferences? fromMap(themeVal) {
    throw UnimplementedError();
  }
}
