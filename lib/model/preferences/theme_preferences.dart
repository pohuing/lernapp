import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/model/color_pair.dart';

class ThemePreferences {
  static const String paintAAKey = 'paintAA';
  static const String blendAAKey = 'blendAA';
  static const String correctionColorsKey = 'correctionColors';

  final bool paintAA;
  static const bool defaultPaintAA = false;
  final bool blendAA;
  static const bool defaultBlendAA = false;
  final ColorPair correctionColors;

  ThemePreferences(this.paintAA, this.blendAA, ColorPair? correctionColors)
      : correctionColors = correctionColors ?? ColorPair.correctionColors;

  ThemePreferences.defaults()
      : paintAA = defaultPaintAA,
        blendAA = defaultBlendAA,
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

  static ThemePreferences? fromMap(Map map) {
    final blendAA = _extractBlendAA(map) ?? defaultBlendAA;
    final paintAA = _extractPaintAA(map) ?? defaultPaintAA;
    final correctionColors =
        _extractCorrectionColors(map) ?? ColorPair.correctionColors;

    return ThemePreferences(paintAA, blendAA, correctionColors);
  }

  static bool? _extractPaintAA(Map map) {
    if (map.containsKey(paintAAKey)) {
      try {
        return map[paintAAKey] as bool;
      } catch (e) {
        log(e.toString(), name: 'ThemePreferences._extractPaintAA');
      }
    }

    return null;
  }

  static bool? _extractBlendAA(Map map) {
    if (map.containsKey(blendAAKey)) {
      try {
        return map[blendAAKey] as bool;
      } catch (e) {
        log(e.toString(), name: 'ThemePreferences._extractBlendAA');
      }
    }

    return null;
  }

  static ColorPair? _extractCorrectionColors(Map map) {
    if (map.containsKey(correctionColorsKey)) {
      return ColorPair.fromMap(map[correctionColorsKey]);
    }

    return null;
  }
}
