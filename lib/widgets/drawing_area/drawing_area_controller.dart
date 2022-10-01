import 'package:flutter/material.dart';
import 'package:lernapp/model/color_pair.dart';

class DrawingAreaController {
  TapMode tapMode = TapMode.draw;
  double xOffset = 0;
  double yOffset = 0;

  double penSize = 1;
  double eraserSize = 5;

  ColorPair currentColor =
      const ColorPair(brightTheme: Colors.black, darkTheme: Colors.white);
}

enum TapMode { draw, pan, erase }
