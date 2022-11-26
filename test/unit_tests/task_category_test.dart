import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/model/task_category.dart';

void main() {
  test('serialize TaskCategory', () {
    final original = TaskCategory(
      title: 'CategoryTitle',
      subCategories: [TaskCategory(title: 'title')],
      tasks: [
        Task('title', 'description', 'hint', 'solution'),
      ],
    );

    final serialized = original.toMap();

    expect(serialized[TaskCategory.titleKey], original.title);
    expect(serialized[TaskCategory.uuidKey], original.uuid.uuid);
    expect(
      serialized[TaskCategory.subCategoriesKey],
      original.subCategories.map((e) => e.toMap()).toList(),
    );
    expect(
      serialized[TaskCategory.tasksKey],
      original.tasks.map((e) => e.toMap()).toList(),
    );
  });

  test('deserialize TaskCategory', () {});
}
