import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/model/line.dart';
import 'package:lernapp/model/solution_state.dart';
import 'package:lernapp/model/task.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Task', () {
    test('serialize Task', () {
      final original = Task('title', 'taskDescription', 'hint', 'solution');

      final serialized = original.toMap();

      expect(
        serialized[Task.uuidKey],
        original.uuid.toString(),
        reason:
            'mismatch, original: ${original.uuid}, serialized: ${serialized[Task.uuidKey]}',
      );
      expect(
        serialized[Task.taskTitleKey],
        original.taskTitle,
        reason:
            'mismatch, original: ${original.taskTitle}, serialized: ${serialized[Task.taskTitleKey]}',
      );
      expect(
        serialized[Task.taskBodyKey],
        original.taskBody,
        reason:
            'mismatch, original: ${original.taskBody}, serialized: ${serialized[Task.taskBodyKey]}',
      );
      expect(
        serialized[Task.solutionBodyKey],
        original.solutionBody,
        reason:
            'mismatch, original: ${original.solutionBody}, serialized: ${serialized[Task.solutionBodyKey]}',
      );
      expect(
        serialized[Task.solutionTitleKey],
        original.solutionTitle,
        reason:
            'mismatch, original: ${original.solutionTitle}, serialized: ${serialized[Task.solutionTitleKey]}',
      );
      expect(
        serialized[Task.solutionsKey],
        original.solutions.map((e) => e.toMap()).toList(),
        reason:
            'mismatch, original: ${original.solutions}, serialized: ${serialized[Task.solutionsKey]}',
      );
    });

    test('deserialize Task', () {
      final uuid = const Uuid().v4obj();
      const title = 'title';
      const description = 'description';
      const hint = 'hint';
      const solution = 'solution';
      final solutionStates = [
        SolutionState([
          Line.withDefaultProperties([Offset.zero]),
          Line.withDefaultProperties([Offset.zero]),
        ]),
      ];

      final original = {
        Task.uuidKey: uuid.toString(),
        Task.taskTitleKey: title,
        Task.taskBodyKey: description,
        Task.solutionBodyKey: hint,
        Task.solutionTitleKey: solution,
        Task.solutionsKey: solutionStates.map((e) => e.toMap()).toList(),
      };

      final deserialized = Task.fromMap(original)!;
      expect(
        deserialized.uuid,
        uuid,
        reason:
            'uuid mismatch, original: $uuid, deserialized: ${deserialized.uuid}',
      );
      expect(
        deserialized.taskTitle,
        title,
        reason:
            'title mismatch, original: $title, deserialized: ${deserialized.taskTitle}',
      );
      expect(
        deserialized.taskBody,
        description,
        reason:
            'description mismatch, original: $description, deserialized: ${deserialized.taskBody}',
      );
      expect(
        deserialized.solutionBody,
        hint,
        reason:
            'hint mismatch, original: $hint, deserialized: ${deserialized.solutionBody}',
      );
      expect(
        deserialized.solutionTitle,
        solution,
        reason:
            'solution mismatch, original: $solution, deserialized: ${deserialized.solutionTitle}',
      );
      expect(
        deserialized.solutions,
        solutionStates,
        reason:
            'lines mismatch, original: $solutionStates, deserialized: ${deserialized.solutions}',
      );
    });

    test('back and forth', () {
      final original = Task('title', 'taskDescription', 'hint', 'solution');
      final serialized = original.toMap();

      final deserialized = Task.fromMap(serialized);
      expect(
        deserialized,
        original,
        reason:
            'task mismatch, original: $original, serialized: $serialized, deserialized: $deserialized',
      );
    });
  });
}
