import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/model/line.dart';
import 'package:system_theme/system_theme.dart';

class DrawingAreaPainter extends CustomPainter {
  Line line;
  final List<Line> lines;
  final double xOffset;
  final double yOffset;
  final Offset? eraserAt;
  final double eraserSize;
  final bool antiAliasBlend;
  final bool antiAliasPaint;

  // used for redraw testing for when system theme has changed since last paint
  bool? lastPaintTheme;
  int? lastPaintHashCode;

  DrawingAreaPainter({
    required this.line,
    required this.lines,
    required this.xOffset,
    required this.yOffset,
    this.eraserAt,
    double? eraserSize,
    bool? antiAliasBlend,
    bool? antiAliasPaint,
  })  : antiAliasBlend = antiAliasBlend ?? false,
        antiAliasPaint = antiAliasPaint ?? false,
        eraserSize = eraserSize ?? 2;

  @override
  void paint(Canvas canvas, Size size) {
    final isDarkMode = SystemTheme.isDarkMode;
    final intransparentPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = antiAliasPaint;
    final eraserPaint = Paint()
      ..color = isDarkMode ? Colors.white : Colors.black
      ..isAntiAlias = antiAliasPaint;

    if (eraserAt != null) {
      canvas.drawCircle(
        eraserAt!,
        eraserSize,
        eraserPaint,
      );
    }

    canvas.translate(xOffset, yOffset);

    for (int i = 0; i < lines.length; i++) {
      final blendPaint = Paint();
      blendPaint.color = lines[i].paintColor;
      intransparentPaint.strokeWidth = lines[i].size;
      intransparentPaint.color = lines[i].paintColor.withAlpha(255);
      intransparentPaint.isAntiAlias = antiAliasPaint;
      final hasTransparency = lines[i].paintColor.alpha != 255;

      if (hasTransparency) {
        // Drawing the layer with an intransparent paint and later restoring with
        // a transparent paint avoids overlaps between start and end of a line
        // segment
        canvas.saveLayer(canvas.getLocalClipBounds(), blendPaint);
      }
      canvas.drawPoints(PointMode.polygon, lines[i].path, intransparentPaint);
      if (hasTransparency) {
        canvas.restore();
      }
    }

    intransparentPaint.color = line.paintColor.withAlpha(255);
    intransparentPaint.strokeWidth = line.size;
    if (line.path.isEmpty) {
    } else if (line.path.length == 1) {
      canvas.drawPoints(PointMode.points, line.path, intransparentPaint);
    } else {
      final blendPaint = Paint()
        ..color = line.paintColor
        ..isAntiAlias = antiAliasBlend;
      canvas.saveLayer(canvas.getLocalClipBounds(), blendPaint);
      canvas.drawPoints(PointMode.polygon, line.path, intransparentPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant DrawingAreaPainter oldDelegate) {
    final start = DateTime.now();
    lastPaintHashCode = _generateHashCode();
    log('Took ${DateTime.now().difference(start).inMicroseconds}microseconds to calculate hash',
        name: 'DrawingAreaPainter.shouldRepaint');
    lastPaintTheme = SystemTheme.isDarkMode;
    var result = oldDelegate.lastPaintHashCode != lastPaintHashCode ||
        oldDelegate.eraserAt != eraserAt ||
        oldDelegate.lastPaintTheme != lastPaintTheme;
    if (kDebugMode) {
      log(result.toString(), name: 'DrawingAreaPainter.shouldRepaint()');
      log(
        'Took ${DateTime.now().difference(start).inMicroseconds}μs checking repaint',
        name: 'DrawingAreaPainter.shouldRepaint',
      );
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
