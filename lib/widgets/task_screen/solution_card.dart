import 'package:flutter/material.dart';

import '../general_purpose/scrollable_selectable_text.dart';

class SolutionCard extends StatelessWidget {
  final String solution;

  const SolutionCard({Key? key, required this.solution}) : super(key: key);

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
                // ignore: avoid_returning_null_for_void
                onPressed: () => null,
                icon: const Icon(Icons.flip),
              ),
            )
          ],
        ),
      ),
    );
  }
}
