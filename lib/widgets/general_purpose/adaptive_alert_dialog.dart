import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// An Alert Dialog that shows CupertinoAlertDialog on ios and macos
class AdaptiveAlertDialog extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget? content;

  const AdaptiveAlertDialog({
    super.key,
    required this.title,
    required this.actions,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        actions: actions,
        content: content,
      );
    } else {
      return AlertDialog(
        title: Text(title),
        actions: actions,
        content: content,
      );
    }
  }
}
