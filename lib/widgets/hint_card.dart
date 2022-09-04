import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

class HintCard extends StatelessWidget {
  const HintCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          lorem(words: 20),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
