import 'package:flutter/material.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area_controller.dart';

import '../../model/line.dart';
import 'drawing_area_painter.dart';

class DrawingArea extends StatefulWidget {
  final DrawingAreaController controller;

  final List<Line>? lines;
  final Function(List<Line> lines)? onEdited;

  DrawingArea({
    Key? key,
    DrawingAreaController? controller,
    this.onEdited,
    this.lines,
  })  : controller = controller ?? DrawingAreaController(),
        super(key: key);

  @override
  State<DrawingArea> createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  Line line = Line([]);
  late final List<Line> lines;

  late final DrawingAreaController controller;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: DrawingAreaPainter(
            line: line.path,
            lines: lines,
            xOffset: controller.xOffset,
            yOffset: controller.yOffset,
          ),
        ),
      ),
    );
  }

  void drawAt(Offset localPosition) {
    final point =
        localPosition.translate(-controller.xOffset, -controller.yOffset);
    line.add(point);
  }

  void eraseAt(Offset localPosition) {
    for (var i = 0; i < lines.length; ++i) {
      lines.removeWhere(
        (line) => line.isInCircle(
          localPosition.translate(-controller.xOffset, -controller.yOffset),
          controller.eraserSize,
        ),
      );
    }
    widget.onEdited?.call(List.from(lines));
  }

  @override
  void initState() {
    controller = widget.controller;
    lines = List.from(widget.lines ?? []);
    super.initState();
  }

  void onPanEnd(DragEndDetails details) {
    switch (controller.tapMode) {
      case TapMode.draw:
        setState(() {
          lines.add(line);
          line = Line([]);
        });
        widget.onEdited?.call(List.from(lines));
        break;
      default:
        break;
    }
  }

  void onPanStart(DragStartDetails details) {
    switch (controller.tapMode) {
      case TapMode.draw:
        setState(() {
          drawAt(details.localPosition);
        });
        break;
      case TapMode.erase:
        setState(() {
          eraseAt(details.localPosition);
        });
        break;
      default:
        break;
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    switch (controller.tapMode) {
      case TapMode.pan:
        setState(() {
          controller.xOffset += details.delta.dx;
          controller.yOffset += details.delta.dy;
        });
        break;
      case TapMode.draw:
        setState(() {
          drawAt(details.localPosition);
        });
        break;
      case TapMode.erase:
        setState(() {
          eraseAt(details.localPosition);
        });
        break;
    }
  }
}
