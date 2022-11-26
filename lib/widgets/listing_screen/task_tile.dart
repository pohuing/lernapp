import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';

import '../../model/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final int? depth;

  const TaskTile({Key? key, required this.task, this.depth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
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
              title: Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
              ),
              leading: state.isSelecting
                  ? Checkbox(
                      value: state.selectedUuids.contains(task.uuid),
                      onChanged: (value) => context
                          .read<SelectionCubit>()
                          .toggleSelection(task.uuid),
                    )
                  : null,
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
      ),
    );
  }
}
