import 'dart:ui';

extension VectorOperations on Offset {
  double dot(Offset other) {
    return dx * other.dx + dy * other.dy;
  }

  Offset normalised() {
    return Offset(dx / distance, dy / distance);
  }

  Offset scalarMul(double factor) {
    return Offset(dx * factor, dy * factor);
  }
}
