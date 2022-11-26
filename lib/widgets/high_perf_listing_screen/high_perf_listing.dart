import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:lernapp/model/task_category.dart';

import '../../model/high_performance_listing_wrappers.dart';
import '../listing_screen/task_tile.dart';
import 'high_perf_category_tile.dart';

class HighPerfListing extends StatefulWidget {
  final List<TaskCategory> categories;
  final bool withNavBarStyle;

  const HighPerfListing({
    Key? key,
    required this.categories,
    required this.withNavBarStyle,
  }) : super(key: key);

  @override
  State<HighPerfListing> createState() => _HighPerfListingState();
}

class _HighPerfListingState extends State<HighPerfListing> {
  late final List<ListingEntryCategory> entries;

  @override
  Widget build(BuildContext context) {
    final flattened = <ListingEntryBase>[];

    for (int i = 0; i < entries.length; i++) {
      flattened.add(entries[i]);
      final c = entries[i].getVisibleChildren().flattened.toList();
      flattened.addAll(c);
    }

    return ImplicitlyAnimatedList(
      itemData: flattened,
      primary: true,
      itemBuilder: (context, entry) {
        if (entry is ListingEntryCategory) {
          return HighPerfCategoryTile(
            key: Key(entry.category.uuid.toString()),
            entry: entry,
            asNavigationBarItem: widget.withNavBarStyle,
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
