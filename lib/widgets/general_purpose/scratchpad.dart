import 'package:flutter/material.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area.dart';

import 'platform_adaptive_scaffold.dart';

class Scratchpad extends StatelessWidget {
  const Scratchpad({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformAdaptiveScaffold(
      title: S.of(context).scratchpadScreen_title,
      useSliverAppBar: false,
      allowBackGesture: false,
      previousTitle: S.of(context).listingScreen_title,
      // ignore: prefer_const_literals_to_create_immutables
      body: DrawingArea(lines: []),
    );
  }
}
