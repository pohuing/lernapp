import 'package:flutter/material.dart';

import '../../model/pair.dart';

class DrawingAreaController {
  TapMode tapMode = TapMode.draw;
  double xOffset = 0;
  double yOffset = 0;

  double penSize = 1;
  double eraserSize = 5;

  Pair<Color> currentColor = Pair(Colors.white, Colors.black);
}

enum TapMode { draw, pan, erase }
