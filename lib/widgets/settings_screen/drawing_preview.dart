import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/logic/shapes.dart';
import 'package:lernapp/model/line.dart';
import 'package:lernapp/model/line_type.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area_painter.dart';

class DrawingPreview extends StatelessWidget {
  const DrawingPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: ListTile(
              title: Text(S.of(context).drawingPreview_title),
              subtitle: Text(S.of(context).drawingPreview_description),
              contentPadding: const EdgeInsets.only(left: 16),
            ),
          ),
          BlocBuilder<PreferencesBloc, PreferencesStateBase>(
            builder: (context, state) {
              final width = state.themePreferences.lineWidth;

              final List<Line> lines = [
                Line.withDefaultProperties(
                  [
                    const Offset(10, 90),
                    const Offset(50, 10),
                    const Offset(90, 90),
                  ],
                  size: width,
                ),
                Line.withDefaultProperties(
                  [
                    const Offset(30, 50),
                    const Offset(70, 50),
                  ],
                  size: width,
                ),
                Line.withDefaultProperties(
                  circle(30, 30, const Offset(50, 50)),
                  size: width,
                  colors: state.themePreferences.correctionColors,
                  type: LineType.correction,
                ),
              ];

              return SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: DrawingAreaPainter(
                    line: Line.withDefaultProperties([]),
                    lines: lines,
                    xOffset: 0,
                    yOffset: 0,
                    antiAliasBlend: state.themePreferences.blendAA,
                    antiAliasPaint: state.themePreferences.paintAA,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
