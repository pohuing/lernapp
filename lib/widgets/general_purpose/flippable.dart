import 'package:flutter/material.dart';

class Flippable extends StatefulWidget {
  final Widget front, back;

  const Flippable({super.key, required this.front, required this.back});

  @override
  State<Flippable> createState() => _FlippableState();
}

class _FlippableState extends State<Flippable> {
  var isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isFlipped = !isFlipped),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isFlipped ? widget.back : widget.front,
      ),
    );
  }
}
