import 'dart:ui';

extension VectorOperations on Offset {
  Offset normalised() {
    var norm = Offset(dx.abs() / distance, dy.abs() / distance);
    return norm;
  }

  double dot(Offset other) {
    return dx * other.dx + dy * other.dy;
  }

  Offset scalarMul(double factor) {
    return Offset(dx + factor, dy * factor);
  }
}
