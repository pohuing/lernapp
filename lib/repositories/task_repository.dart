import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/model/custom_date_time_range.dart';
import 'package:uuid/uuid.dart';

import '../model/task.dart';
import '../model/task_category.dart';

/// An implementation of TaskRepositoryBase utilizing Hive boxes
/// Saving individual tasks and categories will just save everything at once
class HiveTaskRepository implements TaskRepositoryBase {
  @override
  final List<TaskCategory> categories;
  final Box<List<dynamic>> box;
  static const tasksKey = 'tasks';

  HiveTaskRepository({required this.box}) : categories = _loadCategories(box);

  static List<TaskCategory> _loadCategories(Box<List<dynamic>> box) {
    final start = DateTime.now();
    final List<TaskCategory> categories = [];
    log('initialising load', name: 'HiveTaskRepository._loadCategories');
    // load from storage if box contains data
    if (box.isNotEmpty && box.containsKey(tasksKey)) {
      final list = List<Map>.from(box.get(tasksKey) ?? [])
          .map((e) => Map<String, dynamic>.from(e));
      for (final categoryMap in list) {
        final category = TaskCategory.fromMap(categoryMap);
        if (category is TaskCategory) {
          categories.add(category);
        } else {
          log(
            'Category Map is not well formed: ${categoryMap.toString()}',
            name: 'HiveTaskRepository._loadCategories',
          );
        }
      }
    } else {
      categories.addAll(_generateCategories());
    }
    log(
      'Finished load, duration: ${DateTime.now().difference(start).inMilliseconds}ms',
      name: 'HiveTaskRepository._loadCategories',
    );
    return categories;
  }

  @override
  Future<Task?> findByUuid(UuidValue uuid) async {
    for (var c in categories) {
      var t = c.findTask(uuid);
      if (t != null) {
        return t;
      }
    }

    return null;
  }

  @override
  Future<void> save() async {
    final start = DateTime.now();
    log('Starting save', name: 'TaskRepository.save');
    await box.delete(tasksKey);
    await box.put(tasksKey, asMap());
    log(
      'Finished save, duration: ${DateTime.now().difference(start).inMilliseconds}ms',
      name: 'HiveTaskRepository.save',
    );
  }

  List<Map<String, dynamic>> asMap() =>
      categories.map((e) => e.toMap()).toList();

  @override
  Future<void> reload() async {
    log('Reloading', name: 'TaskRepository.load');
    categories.clear();
    categories.addAll(_loadCategories(box));
  }

  static List<TaskCategory> _generateCategories() {
    log(
      'Generating default categories',
      name: 'HiveTaskRepository._generateCategories',
    );
    return [
      TaskCategory(
        title: 'Angewandte Informatik',
        tasks: [
          Task(
            'Allgemeine Aufgabe',
            'Diese Aufgabe ist eine Aufgabe für die Kategorie Angewandte Informatik',
            'hint',
            'solution',
          ),
        ],
        subCategories: [
          TaskCategory(
            title: 'Objektorientierte Programmierung',
            tasks: [
              Task(
                'Modellieren eines Kettensägengeschäfts',
                'This task was created in the second level category',
                '',
                'Zeichnung hier',
              ),
            ],
          ),
          TaskCategory(
            title: 'Mathematik für Informatiker',
            tasks: [
              Task(
                'Mengen und Abbildungen',
                'Was ist der Unterschied zwischen = und :=',
                '',
                ':= bedeutet "Ist definiert durch" und \n = vergleicht beide Operaten',
              ),
              Task(
                'Grundbegriffe der Mengenlehre',
                'Durchschnitt von A = { x ∊ Q | x b 5 }, B = { x ∊ Q | x r 5 }',
                '',
                '',
              ),
            ],
          ),
        ],
      ),
      TaskCategory(title: 'Wasser und Bodenmanagement'),
    ];
  }

  @override
  Future<void> wipeStorage() async {
    await box.clear();
    categories.clear();
  }

  @override
  Future<void> saveCategory(TaskCategory category) {
    return save();
  }

  @override
  Future<void> saveTask(Task task) {
    return save();
  }

  @override
  void dispose() {
    box.close();
  }

  @override
  Future<void> import(List<TaskCategory> newCategories) async {
    categories.addAll(newCategories);
    await save();
  }

  @override
  Future<List<TaskCategory>> recent(CustomDateTimeRange range) {
    final results = categories
        .map((e) => e.tasksInRange(range))
        .whereType<TaskCategory>()
        .toList();

    return Future.value(results);
  }

  @override
  Future<bool> moveTask(Task task, UuidValue to) async {
    await deleteTask(task.uuid);
    return await insertTaskAt(task, to);
  }

  @override
  Future<bool> insertTaskAt(Task task, UuidValue uuid) async {
    categories.firstWhere((element) => element.tryInsertAt(task, uuid));
    return false;
  }

  @override
  Future<void> deleteTask(UuidValue uuid) async {
    categories.forEach((element) {
      element.deleteTask(uuid);
    });
  }
}

abstract class TaskRepositoryBase {
  List<TaskCategory> get categories;

  /// Clear all saved Categories, Tasks and associated solutions
  Future<void> wipeStorage();

  /// Load Repository contents from source, discarding current contents
  Future<void> reload();

  /// Commit current repository state to storage, overwriting currently written state
  Future<void> save();

  /// Load a single task from repository
  Future<Task?> findByUuid(UuidValue uuid);

  /// Save category and it's children
  Future<void> saveCategory(TaskCategory category);

  /// Deletes a [Task]
  Future<void> deleteTask(UuidValue uuid);

  /// Save just a task.
  /// Throws if task was not found in hierarchy
  Future<void> saveTask(Task task);

  Future<List<TaskCategory>> recent(CustomDateTimeRange range);

  void dispose();

  /// Import new Categories
  Future<void> import(List<TaskCategory> newCategories);

  /// Move a task by deleting all instances, then inserting [task] in [to]
  ///
  // returns false if the category does not exist
  Future<bool> moveTask(Task task, UuidValue category);

  /// Inserts a task at [category]
  ///
  /// Does *not* check for duplicates
  /// returns false if the category does not exist
  Future<bool> insertTaskAt(Task task, UuidValue category);
}
