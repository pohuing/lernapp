import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/listing_screen/connected_task_listing.dart';
import 'package:lernapp/widgets/task_screen/task_card.dart';

import 'create_task_dialog.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  Task? newTask;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SelectionCubit(),
      child: PlatformAdaptiveScaffold(
        title: 'Editor',
        previousTitle: S.of(context).listingScreen_title,
        primary: true,
        useSliverAppBar: false,
        trailing: buildTrailing(),
        transitionBetweenRoutes: false,
        body: SafeArea(
          child: AdaptiveLayout(
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
                    secondaryAction: (task) =>
                        buildDraggable(task, const Icon(Icons.drag_indicator)),
                  ),
                )
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget? buildTrailing() {
    if (Breakpoints.small.isActive(context)) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (newTask != null)
            Hero(
              tag: 'taskDraggable',
              transitionOnUserGestures: true,
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                  fromHeroContext, toHeroContext) {
                return TaskCard(
                  title: newTask!.taskTitle,
                  body: newTask!.taskBody,
                  showBackButton: false,
                );
              },
              child: buildDraggable(
                newTask!,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.drag_indicator),
                    Text('Task'),
                  ],
                ),
              ),
            ),
          IconButton(onPressed: onTapAdd, icon: const Icon(Icons.add)),
        ],
      );
    }
  }

  Draggable<Task> buildDraggable(Task task, Widget child) {
    return Draggable(
      dragAnchorStrategy: pointerDragAnchorStrategy,
      data: task,
      maxSimultaneousDrags:
          task.taskTitle.isNotEmpty || task.taskBody.isNotEmpty ? 1 : 0,
      feedback: Material(
        child: SizedBox(
          height: 100,
          width: 100,
          child: Transform.translate(
            offset: const Offset(-50, -100),
            child: TaskCard(
              title: task.taskTitle,
              body: task.taskBody,
              showBackButton: false,
            ),
          ),
        ),
      ),
      childWhenDragging: null,
      child: child,
    );
  }

  void onTapAdd() async {
    if (Breakpoints.small.isActive(context)) {
      context.push(
        '/editor/new',
        extra: (Task? task) {
          setState(() => newTask = task);
        },
      );
    }
  }
}
