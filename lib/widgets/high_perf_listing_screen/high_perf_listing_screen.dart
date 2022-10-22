import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/main.dart';
import 'package:lernapp/model/high_performance_listing_wrappers.dart';
import 'package:lernapp/widgets/high_perf_listing_screen/high_perf_listing_tile.dart';
import 'package:lernapp/widgets/listing_screen/task_tile.dart';

class HighPerfListingScreen extends StatefulWidget {
  const HighPerfListingScreen({Key? key}) : super(key: key);

  @override
  State<HighPerfListingScreen> createState() => _HighPerfListingScreenState();
}

class _HighPerfListingScreenState extends State<HighPerfListingScreen> {
  late final List<ListingEntryCategory> entries;

  @override
  Widget build(BuildContext context) {
    final flattened = <ListingEntryBase>[];

    for (int i = 0; i < entries.length; i++) {
      flattened.add(entries[i]);
      final c = entries[i].getVisibleChildren().flattened.toList();
      flattened.addAll(c);
    }

    return ListView.builder(
      itemCount: flattened.length,
      prototypeItem: DummyHighPerfListingTile(),
      itemBuilder: (context, index) {
        final entry = flattened[index];

        if (entry is ListingEntryCategory) {
          return HighPerfListingTile(
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
          );
        }
        return DummyHighPerfListingTile();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    entries = taskRepository.categories
        .map((e) => ListingEntryCategory.fromCategory(e, 0))
        .toList();
  }
}
