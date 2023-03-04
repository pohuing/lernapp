import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/model/high_performance_listing_wrappers.dart';
import 'package:lernapp/model/task_category.dart';
import 'package:uuid/uuid.dart';

import 'task_listing.dart';

/// A wrapper around [TaskListing] which connects the listing to the [TasksBloc]
/// and [SelectionCubit]
class ConnectedTaskListing extends StatefulWidget {
  /// Show the most recent solution's formatted in the subtitle
  final bool showMostRecent;

  /// Allow reordering tasks by drag and dropping them in new categories
  final bool allowReordering;

  const ConnectedTaskListing({
    super.key,
    bool? showMostRecent,
    bool? allowReordering,
  })  : showMostRecent = showMostRecent ?? false,
        allowReordering = allowReordering ?? false;

  @override
  State<ConnectedTaskListing> createState() => _ConnectedTaskListingState();
}

class _ConnectedTaskListingState extends State<ConnectedTaskListing> {
  List<ListingEntryCategory> listingEntries = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TaskStorageStateBase>(
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
          updateEntries(state);

          return TaskListing(
            key: Key(state.hashCode.toString()),
            listingEntries: listingEntries,
            showMostRecent: widget.showMostRecent,
            allowReordering: widget.allowReordering,
          );
        } else if (state is TaskStorageLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return Text(state.toString());
        }
      },
    );
  }

  void updateEntries(dynamic state) {
    final contents = state.contents as List<TaskCategory>;
    final Set<UuidValue> oldExpandedCategories = listingEntries
        .map((e) => e.getVisibleChildren())
        .followedBy(
          listingEntries.map(
            (e) => [
              [if (e.isExpanded) e]
            ],
          ),
        )
        .flattened
        .flattened
        .whereType<ListingEntryCategory>()
        .where((e) => e.isExpanded)
        .map((e) => e.category.uuid)
        .toSet();

    listingEntries = contents
        .map((e) => ListingEntryCategory.fromCategory(e, 0))
        .whereType<ListingEntryCategory>()
        .toList()
      ..forEach((element) {
        element.isExpanded =
            oldExpandedCategories.contains(element.category.uuid);
        element.traverse(
          (category) => category.isExpanded =
              oldExpandedCategories.contains(category.category.uuid),
        );
      });
  }
}
