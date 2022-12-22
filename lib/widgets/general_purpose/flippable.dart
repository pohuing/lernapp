import 'package:flutter/material.dart';

class Flippable extends StatefulWidget {
  final Widget front, back;

  /// Callback that is called every time the flippable is flipped. A flippable shows the back widget when flipped
  final void Function(bool isFlipped)? onFlip;

  const Flippable({
    super.key,
    required this.front,
    required this.back,
    this.onFlip,
  });

  @override
  State<Flippable> createState() => _FlippableState();
}

class _FlippableState extends State<Flippable> {
  var isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isFlipped = !isFlipped);
        widget.onFlip?.call(isFlipped);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isFlipped ? widget.back : widget.front,
      ),
    );
  }
}
