import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/model/task_category.dart';
import 'package:lernapp/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

main() async {
  await testImplementation(
    'HiveTaskRepository',
    repoCallback: () async {
      final String randomName = const Uuid().v4();
      Box<List<dynamic>> box =
          await Hive.openBox(randomName, path: 'testRepositories');
      return HiveTaskRepository(box: box);
    },
    tearDownCallback: (repo) async {
      await (repo as HiveTaskRepository).box.deleteFromDisk();
    },
  );
}

/// Run the TaskRepositoryBase test suite
///
/// [title] becomes the group title
/// [repoCallback] is used to create a new repository instance on every test run
/// [tearDownCallback] is used as the [tearDown] for the group, with the
/// repository used for the test supplied as an argument
Future<void> testImplementation(
  String title, {
  required Future<TaskRepositoryBase> Function() repoCallback,
  Future<void> Function(TaskRepositoryBase repo)? tearDownCallback,
}) async {
  group(title, () {
    late TaskRepositoryBase repository;
    setUp(() async => repository = await repoCallback());
    if (tearDownCallback != null) {
      tearDown(() => tearDownCallback.call(repository));
    }

    test('Import category', () async {
      final category = TaskCategory(title: 'TestCategory');
      await repository.import([category]);
      await repository.reload();

      expect(
        repository.categories.map((e) => e.uuid),
        contains(category.uuid),
        reason: 'Repository does not contain uuid of new category',
      );
    });

    test('Import category with task', () async {
      final task = Task('Test task', '', 'hint', 'solution');
      final category = TaskCategory(title: 'Test category');
      category.tasks.add(task);
      await repository.import([category]);
      await repository.reload();
      expect(await repository.findByUuid(task.uuid), equals(task));
    });

    /// This test mutates the local state of a category and a task, then saves, and then reloads
    /// The changes must still be accessible after the reload
    test('Save', () async {
      final category = repository.categories
          .firstWhere((element) => element.tasks.isNotEmpty);
      final task = category.tasks.first;
      final categoryUuid = category.uuid;
      final taskUuid = task.uuid;
      category.title = 'A changed title';
      task.taskTitle = 'A new title';
      await repository.save();
      await repository.reload();
      final loadedCategory = repository.categories
          .firstWhere((element) => element.uuid == categoryUuid);
      final loadedTask = loadedCategory.findTask(taskUuid);
      expect(
        loadedCategory.title,
        category.title,
        reason: 'loaded category is different from stored category',
      );
      expect(
        loadedTask!.taskTitle,
        task.taskTitle,
        reason: 'loaded task is different from stored task',
      );
    });
  });
}
