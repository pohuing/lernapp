import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';

import '../../model/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: task.uuid,
      child: Material(
        child: BlocBuilder<SelectionCubit, SelectionState>(
          builder: (context, state) => ListTile(
            title: Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: state.isSelecting
                ? Checkbox(
                    value: state.selectedUuids.contains(task.uuid),
                    onChanged: (value) => context
                        .read<SelectionCubit>()
                        .toggleSelection(task.uuid),
                  )
                : null,
            onLongPress: () =>
                context.read<SelectionCubit>().enableSelectionMode(),
            onTap: () {
              if (state.isSelecting) {
                context.read<SelectionCubit>().toggleSelection(task.uuid);
              } else {
                context.pushNamed(
                  'Task',
                  params: {'tid': task.uuid.toString()},
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
