import 'package:collection/collection.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/model/task_category.dart';

abstract class ListingEntryBase {
  int get depth;
}

class ListingEntryTask extends ListingEntryBase {
  Task task;

  ListingEntryTask(this.task, this.depth);

  @override
  int depth = 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListingEntryTask &&
          runtimeType == other.runtimeType &&
          task == other.task &&
          depth == other.depth;

  @override
  int get hashCode => task.hashCode ^ depth.hashCode;
}

class ListingEntryCategory extends ListingEntryBase {
  List<ListingEntryCategory> childCategories;
  TaskCategory category;
  bool isExpanded;
  @override
  int depth = 0;

  ListingEntryCategory()
      : childCategories = [],
        category = TaskCategory(title: 'Dummy'),
        isExpanded = false;

  ListingEntryCategory.fromCategory(this.category, this.depth)
      : childCategories = category.subCategories
                ?.map(
                  (e) => ListingEntryCategory.fromCategory(e, depth + 1),
                )
                .toList() ??
            [],
        isExpanded = false;

  Iterable<Iterable<ListingEntryBase>> getVisibleChildren() sync* {
    if (isExpanded) {
      for (int i = 0; i < childCategories.length; i++) {
        yield [
          childCategories[i],
          ...childCategories[i].getVisibleChildren().flattened,
        ];
      }
      if (category.tasks != null) {
        yield category.tasks!.map((e) => ListingEntryTask(e, depth));
      }
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListingEntryCategory &&
          runtimeType == other.runtimeType &&
          childCategories == other.childCategories &&
          category == other.category &&
          isExpanded == other.isExpanded &&
          depth == other.depth;

  @override
  int get hashCode =>
      childCategories.hashCode ^
      category.hashCode ^
      isExpanded.hashCode ^
      depth.hashCode;
}