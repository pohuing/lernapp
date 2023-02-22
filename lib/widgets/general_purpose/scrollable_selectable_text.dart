import 'package:flutter/material.dart';

class ScrollableSelectableText extends StatelessWidget {
  final ScrollController _controller;

  final String text;
  final TextStyle? textTheme;

  ScrollableSelectableText({super.key, required this.text, this.textTheme})
      : _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        controller: _controller,
        child: SingleChildScrollView(
          controller: _controller,
          //TODO reenable selectable text once flutter bug for issue #36
          child: Text(
            text,
            style: textTheme ?? Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
