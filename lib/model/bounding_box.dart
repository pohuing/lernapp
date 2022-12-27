import 'dart:math';
import 'dart:ui';

import 'package:lernapp/model/line.dart';

/// A rectangle representing the extremes of something
class BoundingBox {
  final Offset topRight, bottomLeft;

  /// Create a new Bounding box without checking the relative positioning of the
  /// supplied parameters
  const BoundingBox(this.topRight, this.bottomLeft);

  /// Create a new BoundingBox while asserting that the points are in the
  /// topRight/bottomLeft of the box
  BoundingBox.checked({required this.topRight, required this.bottomLeft})
      : assert(topRight.dx > bottomLeft.dx),
        assert(topRight.dy > bottomLeft.dy);

  /// Create a Bounding box from two points. Spanning the smallest possible
  /// rectangle which contains both points
  factory BoundingBox.fromAB(Offset a, Offset b) {
    final maxX = max(a.dx, b.dx);
    final maxY = max(a.dy, b.dy);
    final minX = min(a.dx, b.dx);
    final minY = min(a.dy, b.dy);

    return BoundingBox(Offset(maxX, maxY), Offset(minX, minY));
  }

  /// Create a [BoundingBox] from a [Line]
  /// Takes into account the line's width during creation
  factory BoundingBox.fromLine(Line line) {
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    double minX = double.infinity;
    double minY = double.infinity;

    for (final point in line.path) {
      maxX = max(maxX, point.dx);
      maxY = max(maxY, point.dy);
      minX = min(minX, point.dx);
      minY = min(minY, point.dy);
    }

    maxX = maxX + line.size / 2;
    maxY = maxY + line.size / 2;
    minX = minX - line.size / 2;
    minY = minY - line.size / 2;

    return BoundingBox(Offset(maxX, maxY), Offset(minX, minY));
  }

  /// A rough test to see if point might be in this
  /// **will result in false positives** around the corners of the box since it just
  /// adds the radius on the edges of the box, instead of actually measuring the
  /// distance from box to point
  bool approxContains(Offset point, [double radius = 0]) {
    return point.dx <= topRight.dx + radius &&
        point.dy <= topRight.dy + radius &&
        bottomLeft.dx <= point.dx + radius &&
        bottomLeft.dy <= point.dy + radius;
  }
}
