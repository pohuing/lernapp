import 'package:hive_flutter/hive_flutter.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:uuid/uuid.dart';

import '../model/task.dart';
import '../model/task_category.dart';

class TaskRepository {
  final List<TaskCategory> categories;
  final Box<List<dynamic>>? box;
  static const tasksKey = 'tasks';

  TaskRepository({this.box}) : categories = _loadCategories(box);

  static List<TaskCategory> _loadCategories([Box<List<dynamic>>? box]) {
    final start = DateTime.now();
    final List<TaskCategory> categories = [];
    log('initialising load', name:'TaskRepository._loadCategories');
    if ((box?.isNotEmpty ?? false) && box!.containsKey(tasksKey)) {
      final list = List<Map>.from(box.get(tasksKey) ?? [])
          .map((e) => Map<String, dynamic>.from(e));
      for (final categoryMap in list) {
        final category = TaskCategory.fromMap(categoryMap);
        if (category is TaskCategory) {
          categories.add(category);
        } else {
          log(
            'Category Map is not well formed: ${categoryMap.toString()}',
            name: 'TaskRepository._loadCategories',
          );
        }
      }
    }else{
      categories.addAll(_generateCategories());
    }
    log('Finished load, duration: ${DateTime.now().difference(start).inMilliseconds}ms');
    return categories;
  }

  Task? findByUuid(UuidValue uuid) {
    for (var c in categories) {
      var t = c.findTask(uuid);
      if (t != null) {
        return t;
      }
    }

    return null;
  }

  void save() async {
    final start = DateTime.now();
    log('Starting save', name: 'TaskRepository.save');
    await box?.delete(tasksKey);
    await box?.put(tasksKey, categories.map((e) => e.toMap()).toList());
    log('Finished save, duration: ${DateTime.now().difference(start).inMilliseconds}ms');
  }

  static List<TaskCategory> _generateCategories() {
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
}
