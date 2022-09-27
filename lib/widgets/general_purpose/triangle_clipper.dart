import 'package:flutter/rendering.dart';

enum TriangleClipDirection { bottomLeft, topRight, topLeft, bottomRight }

class TriangleClipper extends CustomClipper<Path> {
  final TriangleClipDirection direction;

  TriangleClipper(this.direction);

  @override
  Path getClip(Size size) {
    switch (direction) {
      case TriangleClipDirection.topRight:
        return Path()
          ..lineTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height);
      case TriangleClipDirection.bottomLeft:
        return Path()
          ..lineTo(0, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height);
      case TriangleClipDirection.topLeft:
        return Path()
          ..lineTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(0, size.height);
      case TriangleClipDirection.bottomRight:
        return Path()
          ..moveTo(size.width, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, 0)
          ..lineTo(0, size.height);
      default:
        return Path();
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
