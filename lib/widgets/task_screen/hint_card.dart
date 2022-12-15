import 'package:flutter/material.dart';

import '../general_purpose/scrollable_selectable_text.dart';

class HintCard extends StatelessWidget {
  final String hint;

  const HintCard({Key? key, required this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ScrollableSelectableText(text: hint),
            const VerticalDivider(width: 8),
            IgnorePointer(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.flip),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
