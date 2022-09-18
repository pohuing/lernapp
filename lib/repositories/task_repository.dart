import 'package:uuid/uuid.dart';

import '../model/task.dart';
import '../model/task_category.dart';

class TaskRepository {
  final List<TaskCategory> categories;

  TaskRepository() : categories = [];

  TaskRepository.lorem() : categories = _generateCategories();

  Task? findByUuid(UuidValue uuid) {
    for (var c in categories) {
      var t = c.findTask(uuid);
      if (t != null) {
        return t;
      }
    }

    return null;
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
