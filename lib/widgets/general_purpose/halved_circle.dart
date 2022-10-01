import 'package:flutter/cupertino.dart';
import 'package:lernapp/widgets/general_purpose/triangle_clipper.dart';

import 'circle.dart';

class HalvedCircle extends StatelessWidget {
  final Color topLeft, bottomRight;

  const HalvedCircle({
    super.key,
    required this.topLeft,
    required this.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: const TriangleClipper(TriangleClipDirection.topLeft),
          child: Circle(
            color: topLeft,
          ),
        ),
        ClipPath(
          clipper: const TriangleClipper(TriangleClipDirection.bottomRight),
          child: Circle(
            color: bottomRight,
          ),
        )
      ],
    );
  }
}
