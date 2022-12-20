import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScrollableSelectableText extends StatelessWidget {
  final ScrollController _controller;

  final String text;
  final TextStyle? textTheme;

  ScrollableSelectableText({Key? key, required this.text, this.textTheme})
      : _controller = ScrollController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        controller: _controller,
        child: SingleChildScrollView(
          controller: _controller,
          child: SelectableRegion(
            focusNode: FocusNode(),
            selectionControls: Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoTextSelectionControls()
                : MaterialTextSelectionControls(),
            child: Text(
              text,
              style: textTheme ?? Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
