import 'package:flutter/material.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area.dart';

import 'platform_adaptive_scaffold.dart';

class Scratchpad extends StatelessWidget {
  const Scratchpad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAdaptiveScaffold(
      title: 'Scribble',
      useSliverAppBar: false,
      allowBackGesture: false,
      previousTitle: 'Tasks',
      // ignore: prefer_const_literals_to_create_immutables
      body: DrawingArea(lines: []),
    );
  }
}
