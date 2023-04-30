import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/model/line.dart';
import 'package:system_theme/system_theme.dart';

class DrawingAreaPainter extends CustomPainter {
  final Line line;
  final List<Line> lines;
  final double xOffset;
  final double yOffset;
  final double scale;
  final Offset? eraserAt;
  final double eraserSize;
  final bool antiAliasBlend;
  final bool antiAliasPaint;
  final bool showBoundingBoxes;

  // A tag used for logging
  final String? tag;

  // used for redraw testing for when system theme has changed since last paint
  bool? lastPaintTheme;
  int? lastPaintHashCode;

  DrawingAreaPainter({
    required this.line,
    this.lines = const [],
    required this.xOffset,
    required this.yOffset,
    this.eraserAt,
    this.tag,
    double? eraserSize,
    bool? antiAliasBlend,
    bool? antiAliasPaint,
    bool? showBoundingBoxes,
    double? scale,
  })  : antiAliasBlend = antiAliasBlend ?? false,
        antiAliasPaint = antiAliasPaint ?? false,
        eraserSize = eraserSize ?? 2,
        showBoundingBoxes = showBoundingBoxes ?? false,
        scale = scale ?? 1;

  @override
  void paint(Canvas canvas, Size size) {
    final isDarkMode = SystemTheme.isDarkMode;
    final intransparentPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = antiAliasPaint;

    if (eraserAt != null) {
      final eraserPaint = Paint()
        ..color = isDarkMode ? Colors.white : Colors.black
        ..isAntiAlias = antiAliasPaint;
      canvas.drawCircle(
        eraserAt!,
        eraserSize,
        eraserPaint,
      );
    }

    canvas.translate(xOffset, yOffset);
    canvas.scale(scale);

    for (int i = 0; i < lines.length; i++) {
      intransparentPaint.strokeWidth = lines[i].size;
      intransparentPaint.color = lines[i].paintColor.withAlpha(255);
      final hasTransparency = lines[i].paintColor.alpha != 255;

      if (showBoundingBoxes) {
        var rect = Rect.fromPoints(
          lines[i].boundingBox.bottomLeft,
          lines[i].boundingBox.topRight,
        );
        canvas.drawRect(
          rect,
          intransparentPaint..style = PaintingStyle.stroke,
        );
      }

      if (hasTransparency) {
        final blendPaint = Paint();
        blendPaint.color = lines[i].paintColor;
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
    } else {
      final hasTransparency = line.paintColor.alpha != 255;
      if (showBoundingBoxes) {
        canvas.drawRect(
          Rect.fromPoints(
            line.boundingBox.bottomLeft,
            line.boundingBox.topRight,
          ),
          intransparentPaint..style = PaintingStyle.stroke,
        );
      }
      if (hasTransparency) {
        final blendPaint = Paint()
          ..color = line.paintColor
          ..isAntiAlias = antiAliasBlend;
        canvas.saveLayer(canvas.getLocalClipBounds(), blendPaint);
      }
      canvas.drawPoints(PointMode.polygon, line.path, intransparentPaint);
      if (hasTransparency) {
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingAreaPainter oldDelegate) {
    final start = DateTime.now();
    lastPaintHashCode = _generateHashCode();
    log(
      'Took ${DateTime.now().difference(start).inMicroseconds}μs to calculate hash',
      name: 'DrawingAreaPainter($tag).shouldRepaint',
    );
    lastPaintTheme = SystemTheme.isDarkMode;
    var result = oldDelegate.lastPaintHashCode != lastPaintHashCode ||
        oldDelegate.eraserAt != eraserAt ||
        oldDelegate.lastPaintTheme != lastPaintTheme;
    if (kDebugMode) {
      log(result.toString(), name: 'DrawingAreaPainter($tag).shouldRepaint');
      log(
        'Took ${DateTime.now().difference(start).inMicroseconds}μs checking repaint',
        name: 'DrawingAreaPainter($tag).shouldRepaint',
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
        yOffset.hashCode ^
        scale.hashCode;
  }
}
