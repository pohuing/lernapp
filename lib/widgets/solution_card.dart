import 'package:flutter/material.dart';

class SolutionCard extends StatelessWidget {
  final String solution;

  const SolutionCard({Key? key, required this.solution}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SelectableText(
          solution,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
