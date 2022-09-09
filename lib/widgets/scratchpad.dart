import 'package:flutter/material.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area.dart';

class Scratchpad extends StatelessWidget {
  const Scratchpad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scribble')),
      body: DrawingArea(),
    );
  }
}
