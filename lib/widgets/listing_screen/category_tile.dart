import 'package:flutter/material.dart';
import 'package:lernapp/widgets/listing_screen/listing_tile.dart';

import '../../model/task_category.dart';

class CategoryTile extends StatefulWidget {
  final TaskCategory category;

  const CategoryTile({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  var isExpanded = false;
  late final TaskCategory category;

  @override
  void initState() {
    category = widget.category;
    super.initState();
  }

  EdgeInsetsGeometry get childPadding {
    return const EdgeInsets.only(left: 16);
  }

  Widget? get trailingElement {
    if (category.numberOfChildren > 0) {
      return null;
    } else {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          start: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: ExpansionTile(
        title: Text(widget.category.title),
        childrenPadding: childPadding,
        maintainState: true,
        trailing: trailingElement,
        children: [
          ...?category.subCategories
              ?.map((e) => CategoryTile(category: e))
              .toList(),
          ...?category.tasks?.map(
            (e) => TaskTile(task: e),
          )
        ],
      ),
    );
  }
}
