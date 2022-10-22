import 'package:flutter/material.dart';
import 'package:lernapp/model/high_performance_listing_wrappers.dart';

class HighPerfListingTile extends StatelessWidget {
  final ListingEntryCategory entry;
  final Function()? onTap;

  const HighPerfListingTile({Key? key, required this.entry, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: entry.depth * 16),
      child: ListTile(
        onTap: () {
          onTap?.call();
        },
        trailing: IgnorePointer(
          child: ExpandIcon(
            onPressed: (_) => null,
            isExpanded: entry.isExpanded,
          ),
        ),
        title: Text(
          entry.category.title,
          style: Theme.of(context).textTheme.titleMedium!,
        ),
      ),
    );
  }
}

class DummyHighPerfListingTile extends HighPerfListingTile {
  DummyHighPerfListingTile({Key? key})
      : super(key: key, entry: ListingEntryCategory());
}
