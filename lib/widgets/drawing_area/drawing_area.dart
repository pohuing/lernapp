import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area_controller.dart';

import '../../model/line.dart';
import 'drawing_area_painter.dart';

class DrawingArea extends StatefulWidget {
  final DrawingAreaController controller;

  final List<Line>? lines;
  final Function(List<Line> lines)? onEdited;
  final bool showEraser;

  DrawingArea({
    Key? key,
    DrawingAreaController? controller,
    this.onEdited,
    this.lines,
    bool? showEraser,
  })  : controller = controller ?? DrawingAreaController(),
        showEraser = showEraser ?? false,
        super(key: key);

  @override
  State<DrawingArea> createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  late final DrawingAreaController controller;
  late Line line;
  late final List<Line> lines;
  Offset? lastPosition;

  Paint get defaultPaint {
    final paint = Paint();
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = controller.penSize;

    return paint;
  }

  Offset? get processedLastPosition => widget.showEraser ? lastPosition : null;

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
            line: line,
            lines: lines,
            xOffset: controller.xOffset,
            yOffset: controller.yOffset,
            eraserPosition: processedLastPosition,
            eraserSize: controller.eraserSize,
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
    line = Line([], controller.currentColor, controller.penSize);
    lines = List.from(widget.lines ?? []);
    super.initState();
  }

  void onPanEnd(DragEndDetails details) {
    if (kDebugMode) {
      log('pan ended', name: 'DrawingArea.onPanEnd()');
    }
    switch (controller.tapMode) {
      case TapMode.draw:
        setState(() {
          lines.add(line);
          line = Line([], controller.currentColor.copy(), controller.penSize);
        });
        widget.onEdited?.call(List.from(lines));
        break;
      case TapMode.erase:
        setState(() {
          lastPosition = null;
        });
        break;
      default:
        break;
    }
  }

  void onPanStart(DragStartDetails details) {
    switch (controller.tapMode) {
      case TapMode.draw:
        setState(() {
          line = Line([], controller.currentColor, controller.penSize);
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
          lastPosition = details.localPosition;
          eraseAt(details.localPosition);
        });
        break;
    }
  }
}
