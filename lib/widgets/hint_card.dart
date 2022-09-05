import 'package:flutter/material.dart';

class HintCard extends StatelessWidget {
  final String hint;

  const HintCard({Key? key, required this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          hint,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
