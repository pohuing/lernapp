import 'package:flutter/material.dart';

class HintCard extends StatelessWidget {
  final String hint;

  const HintCard({super.key, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(hint),
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
