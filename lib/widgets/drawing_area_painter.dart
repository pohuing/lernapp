import 'dart:developer';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../model/line.dart';

class DrawingAreaPainter extends CustomPainter {
  static final linePaint = Paint();
  final List<Offset> line;
  final List<Line> lines;
  double xOffset = 0;
  double yOffset = 0;

  DrawingAreaPainter({
    this.line = const [],
    this.lines = const [],
    this.xOffset = 0,
    this.yOffset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(xOffset, yOffset);
    for (var line in lines) {
      for (var i = 0; i < line.path.length - 1; ++i) {
        canvas.drawLine(line.path[i], line.path[i + 1], linePaint);
      }
    }
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
      //if (equals) log('Redrawing', name: 'DrawingAreaPainter.shouldRepaint');
      return equals;
    } else {
      log(
        'Got old painter that is not DrawingAreaPainter ${oldDelegate.runtimeType}',
        name: 'DrawingAreaPainter.shouldRepaint()',
      );
      return true;
    }
  }
}
