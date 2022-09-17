import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/model/line.dart';
import 'package:system_theme/system_theme.dart';

class DrawingAreaPainter extends CustomPainter {
  Line line;
  final List<Line> lines;
  double xOffset = 0;
  double yOffset = 0;
  Offset? eraserPosition;
  double eraserSize;

  bool? lastPaintTheme;
  int? lastPaintHashCode;

  DrawingAreaPainter({
    required this.line,
    this.lines = const [],
    this.xOffset = 0,
    this.yOffset = 0,
    this.eraserPosition,
    double? eraserSize,
  }) : eraserSize = eraserSize ?? 2;

  @override
  void paint(Canvas canvas, Size size) {
    final isDarkMode = SystemTheme.isDarkMode;
    lastPaintTheme = isDarkMode;
    final eraserPaint = Paint()
      ..color = isDarkMode ? Colors.white : Colors.black;

    if (eraserPosition != null) {
      canvas.drawCircle(
        eraserPosition!,
        eraserSize,
        eraserPaint,
      );
    }

    canvas.translate(xOffset, yOffset);
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      paint
        ..color = line.paintColor
        ..strokeWidth = line.size;
      for (var i = 0; i < line.path.length - 1; ++i) {
        canvas.drawLine(line.path[i], line.path[i + 1], paint);
      }
    }
    paint
      ..color = line.paintColor
      ..strokeWidth = line.size;
    if (line.path.isEmpty) {
    } else if (line.path.length == 1) {
      canvas.drawPoints(PointMode.points, line.path, paint);
    } else {
      for (var i = 0; i < line.path.length - 1; ++i) {
        canvas.drawLine(line.path[i], line.path[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingAreaPainter oldDelegate) {
    lastPaintHashCode = _generateHashCode();
    var result = oldDelegate.lastPaintHashCode != lastPaintHashCode ||
        oldDelegate.eraserPosition != eraserPosition ||
        oldDelegate.lastPaintTheme != lastPaintTheme;
    if (kDebugMode) {
      log(result.toString(), name: 'DrawingAreaPainter.shouldRepaint()');
    }
    return result;
  }

  int _generateHashCode() {
    return lines.fold(
          line.hashCode,
          (previousValue, element) => previousValue ^ element.hashCode,
        ) ^
        xOffset.hashCode ^
        yOffset.hashCode;
  }
}
