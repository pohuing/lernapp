import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/model/line.dart';

import 'drawing_area_controller.dart';
import 'drawing_area_painter.dart';

export 'drawing_area_controller.dart';

class DrawingArea extends StatefulWidget {
  final DrawingAreaController controller;

  final List<Line> lines;
  final Function(List<Line> lines)? onEdited;
  final bool showEraser;

  DrawingArea({
    super.key,
    DrawingAreaController? controller,
    this.onEdited,
    required this.lines,
    bool? showEraser,
  })  : controller = controller ?? DrawingAreaController(),
        showEraser = showEraser ?? false;

  @override
  State<DrawingArea> createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  late final DrawingAreaController controller;
  late Line line;
  Offset? _eraserPosition;
  int? activePointerId;

  Paint get defaultPaint {
    final paint = Paint();
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = controller.penSize;

    return paint;
  }

  Offset? get eraserAt => widget.showEraser ? _eraserPosition : null;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesStateBase>(
      builder: (context, state) => RepaintBoundary(
        child: Listener(
          onPointerDown: onPointerDown,
          onPointerMove: onPointerMove,
          onPointerUp: onPointerUp,
          child: CustomPaint(
            size: MediaQuery.of(context).size,
            isComplex: true,
            foregroundPainter: DrawingAreaPainter(
              tag: 'foreground',
              line: line,
              xOffset: controller.xOffset,
              yOffset: controller.yOffset,
              eraserAt: eraserAt,
              eraserSize: controller.eraserSize,
              antiAliasBlend: state.themePreferences.blendAA,
              antiAliasPaint: state.themePreferences.paintAA,
            ),
            painter: DrawingAreaPainter(
              tag: 'lines',
              line: Line.withDefaultProperties(const []),
              lines: widget.lines,
              xOffset: controller.xOffset,
              yOffset: controller.yOffset,
              antiAliasBlend: state.themePreferences.blendAA,
              antiAliasPaint: state.themePreferences.paintAA,
            ),
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
    for (var i = 0; i < widget.lines.length; ++i) {
      widget.lines.removeWhere(
        (line) => line.isInCircle(
          localPosition.translate(-controller.xOffset, -controller.yOffset),
          controller.eraserSize,
        ),
      );
    }
    widget.onEdited?.call(List.from(widget.lines));
  }

  @override
  void initState() {
    controller = widget.controller;
    line = Line([], controller.currentColor, controller.penSize);
    super.initState();
  }

  void onPanEnd(Offset localPosition) {
    if (kDebugMode) {
      log('pan ended', name: 'DrawingArea.onPanEnd()');
    }
    switch (controller.tapMode) {
      case TapMode.draw:
        setState(() {
          widget.lines.add(line);
          line = Line(
            [],
            controller.currentColor.copy(),
            controller.penSize,
          );
        });
        widget.onEdited?.call(List.from(widget.lines));
        break;
      case TapMode.erase:
        setState(() {
          _eraserPosition = null;
        });
        break;
      default:
        break;
    }
  }

  void onPanStart(Offset localPosition) {
    switch (controller.tapMode) {
      case TapMode.draw:
        setState(() {
          line = Line(
            [],
            controller.currentColor,
            controller.penSize,
          );
          drawAt(localPosition);
        });
        break;
      case TapMode.erase:
        setState(() {
          eraseAt(localPosition);
        });
        break;
      default:
        break;
    }
  }

  void onPanUpdate(Offset localPosition, Offset delta) {
    switch (controller.tapMode) {
      case TapMode.pan:
        setState(() {
          controller.xOffset += delta.dx;
          controller.yOffset += delta.dy;
        });
        break;
      case TapMode.draw:
        setState(() {
          drawAt(localPosition);
        });
        break;
      case TapMode.erase:
        setState(() {
          _eraserPosition = localPosition;
          eraseAt(localPosition);
        });
        break;
    }
  }

  void onPointerDown(PointerDownEvent event) {
    if (activePointerId == null) {
      activePointerId = event.pointer;
      onPanStart(event.localPosition);
    }
  }

  void onPointerMove(PointerMoveEvent event) {
    if (event.pointer == activePointerId) {
      onPanUpdate(event.localPosition, event.delta);
    }
  }

  void onPointerUp(PointerUpEvent event) {
    if (event.pointer == activePointerId) {
      activePointerId = null;
      onPanEnd(event.localPosition);
    }
  }
}
