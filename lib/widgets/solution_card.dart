import 'package:flutter/material.dart';

class SolutionCard extends StatelessWidget {
  const SolutionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'The solution',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
