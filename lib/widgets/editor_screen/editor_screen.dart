import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/listing_screen/connected_task_listing.dart';
import 'package:lernapp/widgets/task_screen/task_card.dart';

import 'create_task_screen.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  @override
  Widget build(BuildContext context) {
    IconButton(onPressed: onTapAdd, icon: const Icon(Icons.add));

    return BlocProvider(
      create: (BuildContext context) => SelectionCubit(),
      child: PlatformAdaptiveScaffold(
        title: 'Tasks',
        primary: true,
        useSliverAppBar: false,
        body: AdaptiveLayout(
          body: SlotLayout(
            config: {
              Breakpoints.standard: SlotLayout.from(
                builder: (context) => const ConnectedTaskListing(
                  key: Key('body'),
                  allowReordering: true,
                ),
                key: const Key('body'),
              ),
            },
          ),
          secondaryBody: SlotLayout(
            key: const Key('secondary'),
            config: {
              Breakpoints.mediumAndUp: SlotLayout.from(
                key: const Key('editor'),
                outAnimation: (widget, animation) {
                  return widget;
                },
                builder: (context) => CreateTaskDialog(
                  secondaryAction: (task) => buildDraggable(task),
                ),
              )
            },
          ),
        ),
      ),
    );
  }

  Draggable<Task> buildDraggable(Task task) {
    return Draggable(
      dragAnchorStrategy: pointerDragAnchorStrategy,
      data: task,
      maxSimultaneousDrags:
          task.title.isNotEmpty || task.description.isNotEmpty ? 1 : 0,
      feedback: Material(
        child: SizedBox(
          height: 100,
          width: 100,
          child: TaskCard(
            title: task.title,
            description: task.description,
            showBackButton: false,
          ),
        ),
      ),
      childWhenDragging: null,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.drag_indicator),
      ),
    );
  }

  void onTapAdd() {
    if (Breakpoints.small.isActive(context)) {
      showModal<Task?>(
        context: context,
        builder: (context) => Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: context.pop,
            label: const Text('confirm'),
            icon: const Icon(Icons.fullscreen_exit),
          ),
          body: const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: CreateTaskDialog(),
          ),
        ),
      );
    }
  }
}
