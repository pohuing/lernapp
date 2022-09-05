import 'package:uuid/uuid.dart';

import '../model/task.dart';

class TaskRepository {
  List<Task> tasks;

  TaskRepository(this.tasks);

  TaskRepository.lorem() : tasks = List.generate(20, (index) => Task.lorem());

  Task findByUuid(UuidValue uuid) {
    return tasks.firstWhere((task) => task.uuid == uuid);
  }
}
