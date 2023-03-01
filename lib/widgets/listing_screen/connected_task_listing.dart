import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';

import 'task_listing.dart';

/// A wrapper around [TaskListing] which connects the listing to the [TasksBloc]
/// and [SelectionCubit]
class ConnectedTaskListing extends StatelessWidget {
  /// Show the most recent solution's formatted in the subtitle
  final bool showMostRecent;

  const ConnectedTaskListing({super.key, bool? showMostRecent})
      : showMostRecent = showMostRecent ?? false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, state) => BlocBuilder<TasksBloc, TaskStorageStateBase>(
        buildWhen: (previous, current) =>
            current is TaskStorageLoaded ||
            current is TaskStorageLoading ||
            current is TaskStorageUninitialized ||
            current is TaskStorageChanged,
        builder: (context, state) {
          if (state is TaskStorageUninitialized) {
            context.read<TasksBloc>().add(TaskStorageLoad());
            return const Center(
              child: Text('Storage is uninitialized'),
            );
          } else if (state is TaskStorageLoaded ||
              state is TaskStorageRepositoryFinishedSaving) {
            if ((state as dynamic).contents.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/import');
                    },
                    child: Text(
                      'You don\'t appear to have any tasks yet. Tap here to import.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              );
            }
            return TaskListing(
              key: Key(state.hashCode.toString()),
              categories: (state as dynamic).contents,
              withNavBarStyle: true,
              showMostRecent: showMostRecent,
            );
          } else if (state is TaskStorageLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            return Text(state.toString());
          }
        },
      ),
    );
  }
}
