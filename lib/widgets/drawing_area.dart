import 'package:flutter/material.dart';
import 'package:lernapp/widgets/drawing_area_painter.dart';

import '../model/line.dart';

class DrawingArea extends StatefulWidget {
  const DrawingArea({Key? key}) : super(key: key);

  @override
  State<DrawingArea> createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  Line line = Line([]);
  final List<Line> lines = [];
  var isMoving = false;
  double xOffset = 0;
  double yOffset = 0;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          GestureDetector(
            onPanStart: onPanStart,
            onPanUpdate: onPanUpdate,
            onPanEnd: onPanEnd,
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: DrawingAreaPainter(
                line: line.path,
                lines: lines,
                xOffset: xOffset,
                yOffset: yOffset,
              ),
            ),
          ),
          Positioned(
            child: IconButton(
              onPressed: () => setState(() => isMoving = !isMoving),
              icon: Icon(isMoving ? Icons.draw : Icons.pan_tool),
            ),
          )
        ],
      ),
    );
  }

  void onPanEnd(DragEndDetails details) {
    if (!isMoving) {
      lines.add(line..prune());
      line = Line([]);
    }
  }

  void onPanStart(DragStartDetails details) {
    if (isMoving) {
      return;
    }
    final point = details.localPosition.translate(-xOffset, -yOffset);
    setState(() {
      line.add(point);
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (isMoving) {
      setState(() {
        xOffset += details.delta.dx;
        yOffset += details.delta.dy;
      });
    } else {
      final point = details.localPosition.translate(-xOffset, -yOffset);
      setState(() {
        line.add(point);
      });
    }
  }
}
