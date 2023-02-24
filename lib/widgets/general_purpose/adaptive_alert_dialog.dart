import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// An Alert Dialog that shows CupertinoAlertDialog on ios and macos
/// Because [CupertinoAlertDialog] is limited to the width of
/// [_kCupertinoDialogWidth](270px, regardless of platform at time of writing)
/// this should not be used for wide contents
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
    if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      return CupertinoAlertDialog(
        title: Text(title),
        actions: [
          if (cancelChild != null)
            CupertinoDialogAction(
              onPressed: onCancel,
              isDestructiveAction: true,
              child: cancelChild!,
            ),
          if (confirmChild != null)
            CupertinoDialogAction(
              onPressed: onConfirm,
              isDefaultAction: true,
              child: confirmChild!,
            ),
        ],
        content: Material(child: content),
      );
    } else {
      return AlertDialog(
        title: Text(title),
        scrollable: true,
        actions: [
          if (cancelChild != null)
            OutlinedButton(onPressed: onCancel, child: cancelChild),
          if (confirmChild != null)
            FilledButton(onPressed: onConfirm, child: confirmChild),
        ],
        content: content,
      );
    }
  }
}
