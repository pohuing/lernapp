import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:lernapp/model/high_performance_listing_wrappers.dart';
import 'package:lernapp/model/task_category.dart';

import 'category_tile.dart';
import 'task_tile.dart';

class TaskListing extends StatefulWidget {
  final List<TaskCategory> categories;
  final bool? shrinkWrap;
  final bool allowTapTasks;
  final bool showMostRecent;

  const TaskListing({
    super.key,
    required this.categories,
    this.shrinkWrap,
    bool? clickableTasks,
    bool? showMostRecent,
  })  : allowTapTasks = clickableTasks ?? true,
        showMostRecent = showMostRecent ?? false;

  @override
  State<TaskListing> createState() => _TaskListingState();
}

class _TaskListingState extends State<TaskListing>
    with AutomaticKeepAliveClientMixin {
  late final List<ListingEntryCategory> entries;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final flattened = <ListingEntryBase>[];

    for (int i = 0; i < entries.length; i++) {
      flattened.add(entries[i]);
      final c = entries[i].getVisibleChildren().flattened.toList();
      flattened.addAll(c);
    }

    return ImplicitlyAnimatedList(
      itemData: flattened,
      initialAnimation: false,
      shrinkWrap: widget.shrinkWrap ?? false,
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

  @override
  void initState() {
    super.initState();
    entries = widget.categories
        .map((e) => ListingEntryCategory.fromCategory(e, 0))
        .whereType<ListingEntryCategory>()
        .toList();
  }
}
