import 'package:flutter/material.dart';
import 'package:lernapp/widgets/drawing_area_painter.dart';

class DrawingArea extends StatefulWidget {
  const DrawingArea({Key? key}) : super(key: key);

  @override
  State<DrawingArea> createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  final List<Offset> points = [];
  var isMoving = false;
  double xOffset = 0;
  double yOffset = 0;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              if (isMoving) {
                return;
              }
              final point = details.localPosition.translate(-xOffset, -yOffset);
              setState(() {
                points.add(point);
              });
            },
            onPanUpdate: (details) {
              if (isMoving) {
                setState(() {
                  xOffset += details.delta.dx;
                  yOffset += details.delta.dy;
                });
              } else {
                final point =
                    details.localPosition.translate(-xOffset, -yOffset);
                setState(() {
                  points.add(point);
                });
              }
            },
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: DrawingAreaPainter(
                points,
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
}
