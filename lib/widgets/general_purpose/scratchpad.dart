import 'package:flutter/material.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area.dart';
import 'package:lernapp/widgets/listing_screen/listing_screen.dart';

class Scratchpad extends StatelessWidget {
  const Scratchpad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAdativeScaffold(
      title: 'Scribble',
      useSliverAppBar: false,
      allowBackGesture: false,
      previousTitle: 'Tasks',
      body: DrawingArea(lines: []),
    );
  }
}
