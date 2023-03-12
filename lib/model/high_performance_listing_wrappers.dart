import 'package:collection/collection.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/model/task_category.dart';
import 'package:uuid/uuid.dart';

abstract class ListingEntryBase {
  int get depth;

  UuidValue get uuid;
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

  @override
  UuidValue get uuid => task.uuid;
}

class ListingEntryCategory extends ListingEntryBase {
  List<ListingEntryCategory> childCategories;
  TaskCategory category;

  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  set isExpanded(v) => _isExpanded = v;
  @override
  int depth = 0;

  ListingEntryCategory()
      : childCategories = [],
        category = TaskCategory(title: 'Dummy');

  ListingEntryCategory.fromCategory(this.category, this.depth)
      : childCategories = category.subCategories
            .map(
              (e) => ListingEntryCategory.fromCategory(e, depth + 1),
            )
            .toList();

  Iterable<Iterable<ListingEntryBase>> getVisibleChildren() sync* {
    if (isExpanded) {
      for (int i = 0; i < childCategories.length; i++) {
        yield [
          childCategories[i],
          ...childCategories[i].getVisibleChildren().flattened,
        ];
      }
      yield category.tasks.map((e) => ListingEntryTask(e, depth));
    }
  }

  /// Calls [action] on all [childCategories], as well as their
  /// [childCategories]
  void traverse(void Function(ListingEntryCategory category) action) {
    childCategories.forEach(action);
    childCategories.forEach((element) => element.traverse(action));
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

  @override
  UuidValue get uuid => category.uuid;
}
