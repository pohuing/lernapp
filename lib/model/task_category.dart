import 'package:lernapp/model/task.dart';
import 'package:uuid/uuid.dart';

class TaskCategory {
  List<TaskCategory>? subCategories;
  List<Task>? tasks;
  String title;

  TaskCategory({required this.title, this.subCategories, this.tasks});

  int get numberOfChildren {
    return (subCategories?.length ?? 0) + (tasks?.length ?? 0);
  }

  /// Recursively search if task in tree
  Task? findTask(UuidValue uuid) {
    Task? task;
    for (var t in tasks ?? <Task>[]) {
      if (t.uuid == uuid) {
        return t;
      }
    }
    if (task == null) {
      for (var c in subCategories ?? <TaskCategory>[]) {
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
    tasks?.forEach((element) => uuids.add(element.uuid));
    subCategories?.forEach((element) => uuids.addAll(element.gatherUuids()));

    return uuids;
  }
}
