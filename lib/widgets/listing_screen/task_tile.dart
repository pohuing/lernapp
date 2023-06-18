import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/widgets/general_purpose/optionally_wrapped.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  /// Indent the tile based on the depth.
  final int? depth;

  /// Allow tapping on tiles to open the task in a separate screen.
  final bool allowTap;

  /// Show the most recent [SolutionState] in the subtitle.
  final bool showMostRecent;

  /// Wraps the tile in a [LongPressDraggable]
  final bool allowDragging;

  const TaskTile({
    super.key,
    required this.task,
    this.depth,
    bool? allowTap,
    bool? showMostRecent,
    bool? allowDragging,
  })  : allowTap = allowTap ?? true,
        showMostRecent = showMostRecent ?? false,
        allowDragging = allowDragging ?? false;

  @override
  Widget build(BuildContext context) {
    return OptionallyWrapped(
      applyWrapper: allowDragging,
      wrapper: (BuildContext context, Widget child) => LongPressDraggable(
        data: task,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: Material(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(task.taskTitle),
            ),
          ),
        ),
        child: child,
      ),
      child: Material(
        child: BlocBuilder<SelectionCubit, SelectionState>(
          builder: (context, state) => Padding(
            padding:
                EdgeInsets.only(left: depth != null ? (depth! + 1) * 16 : 0),
            child: Container(
              decoration: BoxDecoration(
                border: BorderDirectional(
                  start: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: ListTile(
                subtitle: showMostRecent ? Text(task.mostRecentSummary) : null,
                title: MarkdownBody(
                  data: task.taskTitle,
                ),
                leading: state.isSelecting
                    ? Checkbox(
                        value: state.selectedUuids.contains(task.uuid),
                        onChanged: (value) => context
                            .read<SelectionCubit>()
                            .toggleSelection(task.uuid),
                      )
                    : null,
                onTap: !allowTap
                    ? null
                    : () {
                        if (state.isSelecting) {
                          context
                              .read<SelectionCubit>()
                              .toggleSelection(task.uuid);
                        } else {
                          context.pushNamed(
                            'task',
                            pathParameters: {'tid': task.uuid.toString()},
                          );
                        }
                      },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
