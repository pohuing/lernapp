import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lernapp/model/line.dart';

class DrawingAreaPainter extends CustomPainter {
  Line line;
  final List<Line> lines;
  double xOffset = 0;
  double yOffset = 0;

  DrawingAreaPainter({
    required this.line,
    this.lines = const [],
    this.xOffset = 0,
    this.yOffset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(xOffset, yOffset);
    for (var line in lines) {
      for (var i = 0; i < line.path.length - 1; ++i) {
        canvas.drawLine(line.path[i], line.path[i + 1], line.paint);
      }
    }
    if (line.path.isEmpty) {
      return;
    } else if (line.path.length == 1) {
      canvas.drawPoints(PointMode.points, line.path, line.paint);
    } else {
      for (var i = 0; i < line.path.length - 1; ++i) {
        canvas.drawLine(line.path[i], line.path[i + 1], line.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO figure out a more prudent way to detect redraws
    return true;
  }
}
