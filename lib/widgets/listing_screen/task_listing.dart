import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/model/high_performance_listing_wrappers.dart';
import 'package:lernapp/model/task_category.dart';

import 'category_tile.dart';
import 'task_tile.dart';

/// Show [categories] or [listingEntries] in an [AnimatedList]
///
/// If using [listingEntries], the parent is responsible for tracking the
/// entries.
class TaskListing extends StatefulWidget {
  /// Categories to display
  final List<TaskCategory>? categories;
  final List<ListingEntryCategory>? listingEntries;
  final bool shrinkWrap;
  final bool allowTapTasks;
  final bool showMostRecent;

  /// Enables [LongPressDraggable] and the [DropListener] of the children.
  /// This widget will not rebuild after one of the entries has been moved.
  final bool allowReordering;

  const TaskListing({
    super.key,
    this.categories,
    bool? shrinkWrap,
    bool? clickableTasks,
    bool? showMostRecent,
    this.listingEntries,
    bool? allowReordering,
  })  : shrinkWrap = shrinkWrap ?? false,
        allowTapTasks = clickableTasks ?? true,
        showMostRecent = showMostRecent ?? false,
        allowReordering = allowReordering ?? false,
        assert(
          (categories != null) ^ (listingEntries != null),
          'Either categories or listing entries must be non null, not both, not neither',
        );

  @override
  State<TaskListing> createState() => _TaskListingState();
}

class _TaskListingState extends State<TaskListing>
    with AutomaticKeepAliveClientMixin {
  List<ListingEntryCategory> _entriesCache = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List<ListingEntryBase> flattened = [];

    for (int i = 0; i < entries.length; i++) {
      flattened.add(entries[i]);
      final c = entries[i].getVisibleChildren().flattened.toList();
      flattened.addAll(c);
    }

    return ImplicitlyAnimatedList(
      itemData: flattened,
      initialAnimation: false,
      shrinkWrap: widget.shrinkWrap,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, entry) {
        if (entry is ListingEntryCategory) {
          return CategoryTile(
            key: Key(entry.category.uuid.toString()),
            entry: entry,
            onTap: () {
              setState(() {
                entry.isExpanded = !entry.isExpanded;
              });
            },
          );
        } else if (entry is ListingEntryTask) {
          return TaskTile(
            key: Key(entry.task.uuid.toString()),
            task: entry.task,
            depth: entry.depth,
            allowTap: widget.allowTapTasks,
            showMostRecent: widget.showMostRecent,
          );
        }
        return DummyHighPerfListingTile();
      },
    );
  }

  List<ListingEntryCategory> get entries {
    if (widget.listingEntries != null) {
      return widget.listingEntries!;
    }
    if (widget.categories != null) {
      if (_entriesCache.isEmpty) {
        _entriesCache = widget.categories!
            .map((e) => ListingEntryCategory.fromCategory(e, 0))
            .whereType<ListingEntryCategory>()
            .toList();
      }
      return _entriesCache;
    }
    log('Categories and entries is null in state', name: '_TaskListingState');
    return [];
  }
}
