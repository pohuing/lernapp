import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/model/line.dart';

class DrawingAreaPainter extends CustomPainter {
  Line line;
  final List<Line> lines;
  double xOffset = 0;
  double yOffset = 0;
  Offset? eraserAt;
  double eraserSize;

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
    canvas.translate(xOffset, yOffset);
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      for (var i = 0; i < line.path.length - 1; ++i) {
        canvas.drawLine(line.path[i], line.path[i + 1], line.paint);
      }
    }
    if (line.path.isEmpty) {
    } else if (line.path.length == 1) {
      canvas.drawPoints(PointMode.points, line.path, line.paint);
    } else {
      for (var i = 0; i < line.path.length - 1; ++i) {
        canvas.drawLine(line.path[i], line.path[i + 1], line.paint);
      }
    }
    if (eraserAt != null) {
      canvas.drawCircle(eraserAt!, eraserSize, line.paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingAreaPainter oldDelegate) {
    lastPaintHashCode = _generateHashCode();
    var result = oldDelegate.lastPaintHashCode != lastPaintHashCode ||
        oldDelegate.eraserAt != eraserAt;
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
