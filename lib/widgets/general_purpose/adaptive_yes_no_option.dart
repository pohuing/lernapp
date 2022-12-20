import 'package:flutter/material.dart';

class AdaptiveYesNoOption extends StatelessWidget {
  final void Function(bool? newValue)? onChanged;
  final bool value;

  const AdaptiveYesNoOption({super.key, this.onChanged, required this.value});

  @override
  Widget build(BuildContext context) {
    if (const [TargetPlatform.iOS, TargetPlatform.macOS]
        .contains(Theme.of(context).platform)) {
      return Switch.adaptive(value: value, onChanged: onChanged);
    } else {
      return Checkbox(value: value, onChanged: onChanged);
    }
  }
}
