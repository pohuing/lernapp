import 'package:flutter/widgets.dart';

class Circle extends StatelessWidget {
  final Color color;

  const Circle({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
