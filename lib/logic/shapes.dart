import 'dart:math';
import 'dart:ui';

/// Generate a circle
/// Note that the result will have a length of  steps + 1 to close the circle
List<Offset> circle(int steps, double radius, [Offset center = Offset.zero]) {
  final List<Offset> points = [];
  for (int i = 0; i <= steps; i++) {
    points.add(
      Offset.fromDirection(i * (2 * pi / steps), radius)
          .translate(center.dx, center.dy),
    );
  }
  return points;
}
