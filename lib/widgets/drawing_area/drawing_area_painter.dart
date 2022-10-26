import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/model/line.dart';
import 'package:system_theme/system_theme.dart';

class DrawingAreaPainter extends CustomPainter {
  Line line;
  final List<Line> lines;
  double xOffset = 0;
  double yOffset = 0;
  Offset? eraserAt;
  double eraserSize;

  // used for redraw testing for when system theme has changed since last paint
  bool? lastPaintTheme;
  int? lastPaintHashCode;

  DrawingAreaPainter({
    required this.line,
    this.lines = const [],
    this.xOffset = 0,
    this.yOffset = 0,
    this.eraserAt,
    double? eraserSize,
  }) : eraserSize = eraserSize ?? 2;

  @override
  void paint(Canvas canvas, Size size) {
    final isDarkMode = SystemTheme.isDarkMode;
    lastPaintTheme = isDarkMode;
    final eraserPaint = Paint()
      ..color = isDarkMode ? Colors.white : Colors.black;

    if (eraserAt != null) {
      canvas.drawCircle(
        eraserAt!,
        eraserSize,
        eraserPaint,
      );
    }

    canvas.translate(xOffset, yOffset);

    final intransparentPaint = Paint()..strokeCap = StrokeCap.round;

    for (int i = 0; i < lines.length; i++) {
      final blendPaint = Paint();
      blendPaint.color = lines[i].paintColor;
      blendPaint.isAntiAlias = false;
      intransparentPaint.strokeWidth = lines[i].size;
      intransparentPaint.color = lines[i].paintColor.withAlpha(255);
      intransparentPaint.isAntiAlias = true;

      // Drawing the layer with an intransparent paint and later restoring with
      // a transparent paint avoids overlaps between start and end of a line
      // segment
      canvas.saveLayer(canvas.getLocalClipBounds(), blendPaint);
      for (var line in lines[i].windowed) {
        canvas.drawLine(line.one, line.two, intransparentPaint);
      }
      canvas.restore();
    }

    intransparentPaint.color = line.paintColor.withAlpha(255);
    intransparentPaint.strokeWidth = line.size;
    if (line.path.isEmpty) {
    } else if (line.path.length == 1) {
      canvas.drawPoints(PointMode.points, line.path, intransparentPaint);
    } else {
      final blendPaint = Paint();
      blendPaint.color = line.paintColor;
      blendPaint.isAntiAlias = false;
      canvas.saveLayer(canvas.getLocalClipBounds(), blendPaint);
      for (var pair in line.windowed) {
        canvas.drawLine(pair.one, pair.two, intransparentPaint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant DrawingAreaPainter oldDelegate) {
    lastPaintHashCode = _generateHashCode();
    var result = oldDelegate.lastPaintHashCode != lastPaintHashCode ||
        oldDelegate.eraserAt != eraserAt ||
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
