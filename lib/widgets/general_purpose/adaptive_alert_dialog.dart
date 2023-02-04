import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// An Alert Dialog that shows CupertinoAlertDialog on ios and macos
class AdaptiveAlertDialog extends StatelessWidget {
  final String title;
  final Widget? confirmChild;
  final Widget? cancelChild;
  final Function()? onConfirm;
  final Function()? onCancel;

  final Widget? content;

  const AdaptiveAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.confirmChild,
    this.cancelChild,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        actions: [
          if (confirmChild != null)
            CupertinoDialogAction(
              onPressed: onConfirm,
              child: confirmChild!,
            ),
          if (cancelChild != null)
            CupertinoDialogAction(
              onPressed: onCancel,
              child: cancelChild!,
            )
        ],
        content: content,
      );
    } else {
      return AlertDialog(
        title: Text(title),
        scrollable: true,
        actions: [
          if (cancelChild != null)
            OutlinedButton(onPressed: onCancel, child: cancelChild),
          if (cancelChild != null)
            FilledButton(onPressed: onConfirm, child: confirmChild),
        ],
        content: content,
      );
    }
  }
}
