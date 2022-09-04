class DrawingAreaController {
  TapMode tapMode = TapMode.draw;
  double xOffset = 0;
  double yOffset = 0;

  double eraserSize = 5;
}

enum TapMode { draw, pan, erase }
