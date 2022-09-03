import 'package:flutter/material.dart';
import 'package:lernapp/widgets/drawing_area_painter.dart';

class DrawingArea extends StatefulWidget {
  const DrawingArea({Key? key}) : super(key: key);

  @override
  State<DrawingArea> createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  final List<Offset> points = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final box = context.findRenderObject();
        if (box is RenderBox) {
          final point = box.globalToLocal(details.globalPosition);
          setState(() {
            points.add(point);
          });
        }
      },
      onPanUpdate: (details) {
        final box = context.findRenderObject();
        if (box is RenderBox) {
          final point = box.globalToLocal(details.globalPosition);
          setState(() {
            points.add(point);
          });
        }
      },
      child: CustomPaint(
        painter: DrawingAreaPainter(points),
      ),
    );
  }
}
