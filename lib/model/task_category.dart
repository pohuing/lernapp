import 'package:lernapp/model/task.dart';
import 'package:uuid/uuid.dart';

class TaskCategory {
  UuidValue uuid = const Uuid().v4obj();
  List<TaskCategory> subCategories;
  List<Task> tasks;
  String title;

  static const String tasksKey = 'tasks';
  static const String subCategoriesKey = 'subCategories';
  static const String titleKey = 'title';
  static const String uuidKey = 'uuid';

  TaskCategory({
    required this.title,
    List<TaskCategory>? subCategories,
    List<Task>? tasks,
  })  : subCategories = subCategories ?? [],
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
}
