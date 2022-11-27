import 'dart:math' hide log;

import 'package:flutter/material.dart';

/// Shows a snack bar with a [LinearProgressIndicator] as a duration indicator.
void showTimedSnackBar(BuildContext context, String message) {
  {
    final duration = max(4000, message.length * 100);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: duration),
        content: IgnorePointer(
          child: _SnackBarTimerContent(message: message),
        ),
      ),
    );
  }
}

class _SnackBarTimerContent extends StatefulWidget {
  final String message;

  const _SnackBarTimerContent({
    required this.message,
  });

  @override
  State<StatefulWidget> createState() {
    return _SnackBarTimerContentState();
  }
}

class _SnackBarTimerContentState extends State<_SnackBarTimerContent> {
  late final Stream<int> timer;
  late final int duration;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Text(widget.message),
        const SizedBox(height: 16),
        StreamBuilder<int>(
          stream: timer,
          builder: (context, snapshot) => snapshot.hasData
              ? LinearProgressIndicator(
            value: snapshot.data! / duration,
          )
              : Container(),
        )
      ],
    );
  }

  @override
  void initState() {
    duration = max(4000, widget.message.length * 100);
    var endTime = DateTime.now().add(Duration(milliseconds: duration));
    timer = Stream<int>.periodic(
      // At a refresh rate of 144hz, each frame will be visible for 6944 microseconds
      // Using a tick rate way faster that will avoid any skipped steps in the countdown animation
      const Duration(microseconds: 100),
          (computationCount) => (endTime.difference(DateTime.now())).inMilliseconds,
    ).takeWhile(
          (tick) => 0 >= DateTime.now().compareTo(endTime),
    );
    super.initState();
  }
}
