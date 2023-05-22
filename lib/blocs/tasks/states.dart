import 'package:lernapp/model/task_category.dart';

sealed class TaskStorageStateBase {}

class TaskStorageUninitialized implements TaskStorageStateBase {}

class TaskStorageLoading implements TaskStorageStateBase {}

/// Used for States where the Repository has data available
sealed class TaskStorageHasContents implements TaskStorageStateBase {
  List<TaskCategory> get contents;
}

class TaskStorageLoaded implements TaskStorageHasContents {
  @override
  final List<TaskCategory> contents;

  TaskStorageLoaded(this.contents);
}

class TaskStorageRepositoryFinishedSaving implements TaskStorageHasContents {
  @override
  final List<TaskCategory> contents;

  TaskStorageRepositoryFinishedSaving(this.contents);
}

class TaskStorageSaving implements TaskStorageHasContents {
  @override
  final List<TaskCategory> contents;

  TaskStorageSaving(this.contents);
}

class TaskStorageDataChanged implements TaskStorageHasContents {
  @override
  final List<TaskCategory> contents;

  TaskStorageDataChanged(this.contents);
}
