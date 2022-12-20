import 'package:flutter/material.dart';

import '../general_purpose/scrollable_selectable_text.dart';

class SolutionCard extends StatelessWidget {
  final String solution;

  const SolutionCard({super.key, required this.solution});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ScrollableSelectableText(text: solution),
            const VerticalDivider(width: 8),
            IgnorePointer(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.flip),
              ),
            )
          ],
        ),
      ),
    );
  }
}
