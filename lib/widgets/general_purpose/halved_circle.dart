import 'package:flutter/cupertino.dart';
import 'package:lernapp/widgets/general_purpose/triangle_clipper.dart';

import 'circle.dart';

class HalvedCircle extends StatelessWidget {
  final Color a, b;

  const HalvedCircle({super.key, required this.a, required this.b});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: TriangleClipper(TriangleClipDirection.topLeft),
          child: Circle(
            color: a,
          ),
        ),
        ClipPath(
          clipper: TriangleClipper(TriangleClipDirection.bottomRight),
          child: Circle(
            color: b,
          ),
        )
      ],
    );
  }
}
