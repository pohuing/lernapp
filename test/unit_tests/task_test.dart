import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/model/line.dart';
import 'package:lernapp/model/solution_state.dart';
import 'package:lernapp/model/task.dart';
import 'package:uuid/uuid.dart';

void main() {
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
      serialized[Task.titleKey],
      original.title,
      reason:
          'mismatch, original: ${original.title}, serialized: ${serialized[Task.titleKey]}',
    );
    expect(
      serialized[Task.descriptionKey],
      original.description,
      reason:
          'mismatch, original: ${original.description}, serialized: ${serialized[Task.descriptionKey]}',
    );
    expect(
      serialized[Task.hintKey],
      original.hint,
      reason:
          'mismatch, original: ${original.hint}, serialized: ${serialized[Task.hintKey]}',
    );
    expect(
      serialized[Task.solutionKey],
      original.solution,
      reason:
          'mismatch, original: ${original.solution}, serialized: ${serialized[Task.solutionKey]}',
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
        Line.withDefaultProperties([const Offset(0, 0)]),
        Line.withDefaultProperties([const Offset(0, 0)]),
      ]),
    ];

    final original = {
      Task.uuidKey: uuid.toString(),
      Task.titleKey: title,
      Task.descriptionKey: description,
      Task.hintKey: hint,
      Task.solutionKey: solution,
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
      deserialized.title,
      title,
      reason:
          'title mismatch, original: $title, deserialized: ${deserialized.title}',
    );
    expect(
      deserialized.description,
      description,
      reason:
          'description mismatch, original: $description, deserialized: ${deserialized.description}',
    );
    expect(
      deserialized.hint,
      hint,
      reason:
          'hint mismatch, original: $hint, deserialized: ${deserialized.hint}',
    );
    expect(
      deserialized.solution,
      solution,
      reason:
          'solution mismatch, original: $solution, deserialized: ${deserialized.solution}',
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
}
