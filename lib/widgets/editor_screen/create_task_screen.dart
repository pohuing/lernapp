import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/task.dart';
import 'create_task_dialog.dart';

class CreateTaskScreen extends StatelessWidget {
  const CreateTaskScreen({super.key, this.onChange});

  final void Function(Task? task)? onChange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Hero(
        tag: 'taskDraggable',
        transitionOnUserGestures: true,
        flightShuttleBuilder: (flightContext, animation, flightDirection,
                fromHeroContext, toHeroContext) =>
            FloatingActionButton.extended(
          heroTag: null,
          onPressed: context.pop,
          label: const Text('confirm'),
          icon: const Icon(Icons.fullscreen_exit),
        ),
        child: FloatingActionButton.extended(
          heroTag: null,
          onPressed: context.pop,
          label: const Text('confirm'),
          icon: const Icon(Icons.fullscreen_exit),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: CreateTaskDialog(onChange: onChange),
      ),
    );
  }
}
