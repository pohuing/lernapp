import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/logic/map_extensions.dart';
import 'package:lernapp/logic/nullable_extensions.dart';
import 'package:lernapp/model/task.dart';
import 'package:uuid/uuid.dart';

import 'custom_date_time_range.dart';

class TaskCategory {
  UuidValue uuid;
  List<TaskCategory> subCategories;
  List<Task> tasks;
  String title;

  // TODO: Don't let this get into master
  bool expanded;

  static const String tasksKey = 'tasks';
  static const String subCategoriesKey = 'subCategories';
  static const String titleKey = 'title';
  static const String uuidKey = 'uuid';

  TaskCategory({
    required this.title,
    List<TaskCategory>? subCategories,
    List<Task>? tasks,
    UuidValue? id,
    this.expanded = false,
  })  : uuid = id ?? const Uuid().v4obj(),
        subCategories = subCategories ?? [],
        tasks = tasks ?? [];

  int get numberOfChildren {
    return subCategories.length + tasks.length;
  }

  /// Recursively search if task in tree
  Task? findTask(UuidValue uuid) {
    Task? task;
    for (var t in tasks) {
      if (t.uuid == uuid) {
        return t;
      }
    }
    if (task == null) {
      for (var c in subCategories) {
        var t = c.findTask(uuid);
        if (t != null) {
          return t;
        }
      }
    }
    return null;
  }

  /// Recursively gather Uuids of all children
  Set<UuidValue> gatherUuids() {
    Set<UuidValue> uuids = {};
    tasks.forEach((element) => uuids.add(element.uuid));
    subCategories.forEach((element) => uuids.addAll(element.gatherUuids()));

    return uuids;
  }

  Map<String, dynamic> toMap() {
    return {
      uuidKey: uuid.uuid,
      titleKey: title,
      subCategoriesKey: subCategories.map((e) => e.toMap()).toList(),
      tasksKey: tasks.map((e) => e.toMap()).toList(),
    };
  }

  TaskCategory? tasksInRange(CustomDateTimeRange range) {
    final List<TaskCategory> subCategoriesInRange =
        subCategories.fold([], (previousValue, element) {
      final maybeCategory = element.tasksInRange(range);
      maybeCategory.map(previousValue.add);
      return previousValue;
    });
    final tasksInRange = tasks
        .where(
          (t) => t.solutions.any(
            (s) =>
                range.timeIn(s.timestamp) ==
                DateTimeRangeComparisonResult.within,
          ),
        )
        .toList();
    if (subCategoriesInRange.isEmpty && tasksInRange.isEmpty) {
      return null;
    }

    return TaskCategory(
      title: title,
      subCategories: subCategoriesInRange,
      tasks: tasksInRange,
    );
  }

  static TaskCategory? fromMap(Map map) {
    try {
      final uuid = map.transformOrFallback<UuidValue>(
        uuidKey,
        (value) => UuidValue(value),
        const Uuid().v4obj(),
      );
      final title = map[titleKey] as String;
      final subCategories = List<Map>.from(map[subCategoriesKey] ?? [])
          .map(TaskCategory.fromMap)
          .whereType<TaskCategory>()
          .toList();
      final tasks = List<Map>.from(map[tasksKey] ?? [])
          .map(Task.fromMap)
          .whereType<Task>()
          .toList();
      return TaskCategory(
        id: uuid,
        title: title,
        subCategories: subCategories,
        tasks: tasks,
      );
    } catch (e) {
      log(
        'Failed to deserialise TaskCategory: $e',
        name: 'TaskCategory.fromMap',
      );
      return null;
    }
  }

  /// Delete task from this and all child categories
  void deleteTask(UuidValue uuid) {
    tasks.removeWhere((task) => task.uuid == uuid);
    subCategories.forEach((element) => element.deleteTask(uuid));
  }

  /// Tries to insert [task] at [uuid]
  /// returns true if task was successfully inserted in [this] or a subcategory
  bool tryInsertAt(Task task, UuidValue uuid) {
    final cat = findTaskCategory(uuid);
    if (cat != null) {
      cat.tasks.add(task);
      return true;
    }
    return false;
  }

  TaskCategory? findTaskCategory(UuidValue uuid) {
    if (this.uuid == uuid) {
      return this;
    } else {
      for (final category in subCategories) {
        final r = category.findTaskCategory(uuid);
        if (r != null) {
          return r;
        }
      }
    }

    return null;
  }
}
