import 'package:lernapp/model/task_category.dart';

abstract class TaskStorageStateBase {}

class TaskStorageUninitialized implements TaskStorageStateBase {}

class TaskStorageLoading implements TaskStorageStateBase {}

class TaskStorageLoaded implements TaskStorageStateBase {
  final List<TaskCategory> contents;

  TaskStorageLoaded(this.contents);
}

class TaskStorageRepositoryFinishedSaving implements TaskStorageStateBase {
  final List<TaskCategory> contents;

  TaskStorageRepositoryFinishedSaving(this.contents);
}

class TaskStorageSaving implements TaskStorageStateBase {}

class TaskStorageDataChanged implements TaskStorageStateBase {
  final List<TaskCategory> contents;

  TaskStorageDataChanged(this.contents);
}
