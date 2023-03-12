import 'package:lernapp/model/task.dart';
import 'package:lernapp/model/task_category.dart';
import 'package:lernapp/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

abstract class TaskStorageEventBase {}

/// Load data from storage, discarding the current state
class TaskStorageLoad implements TaskStorageEventBase {}

/// Clear the entire storage
class TaskStorageWipe implements TaskStorageEventBase {}

/// Save current storage contents
class TaskStorageSave implements TaskStorageEventBase {}

/// Save changes of a category and it's children
class TaskStorageSaveCategory implements TaskStorageEventBase {
  final TaskCategory category;

  TaskStorageSaveCategory(this.category);
}

/// Save changes to individual task
class TaskStorageSaveTask implements TaskStorageEventBase {
  final Task task;

  TaskStorageSaveTask(this.task);
}

class TaskStorageChanged implements TaskStorageEventBase {
  final TaskRepositoryBase newRepository;

  TaskStorageChanged(this.newRepository);
}

class TaskStorageImportCategories implements TaskStorageEventBase {
  final List<TaskCategory> newCategories;

  TaskStorageImportCategories(this.newCategories);
}

class TaskStorageMoveTask implements TaskStorageEventBase {
  final Task task;
  final UuidValue to;

  TaskStorageMoveTask(this.task, this.to);
}
