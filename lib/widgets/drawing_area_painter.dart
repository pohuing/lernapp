import 'dart:developer';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class DrawingAreaPainter extends CustomPainter {
  static final linePaint = Paint();
  final List<Offset> line;
  double xOffset = 0;
  double yOffset = 0;

  DrawingAreaPainter(this.line, {this.xOffset = 0, this.yOffset = 0});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(xOffset, yOffset);
    if (line.isEmpty) {
      return;
    } else if (line.length == 1) {
      canvas.drawPoints(PointMode.points, line, linePaint);
    } else {
      for (var i = 0; i < line.length - 1; ++i) {
        canvas.drawLine(line[i], line[i + 1], linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is DrawingAreaPainter) {
      var equals = oldDelegate.line.equals(line);
      if (equals) log('Redrawing', name: 'DrawingAreaPainter.shouldRepaint');
      return equals;
    } else {
      return true;
    }
  }
}
