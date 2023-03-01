import 'package:collection/collection.dart';
import 'package:flutter_ameno_ipsum/flutter_ameno_ipsum.dart';
import 'package:lernapp/logic/list_extensions.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/logic/map_extensions.dart';
import 'package:lernapp/model/solution_state.dart';
import 'package:uuid/uuid.dart';

class Task {
  static const uuidKey = 'uuid';
  static const solutionKey = 'solution';
  static const hintKey = 'hint';
  static const descriptionKey = 'description';
  static const titleKey = 'title';
  static const solutionsKey = 'solutions';

  String title;
  String description;
  String hint;
  String solution;
  UuidValue uuid;
  List<SolutionState> solutions;

  Task(
    this.title,
    this.description,
    this.hint,
    this.solution, {
    UuidValue? uuid,
    List<SolutionState>? solutions,
  })  : solutions = solutions ?? [],
        uuid = uuid ?? const Uuid().v4obj();

  Task.lorem()
      : title = ameno(paragraphs: 1, words: 4),
        description = ameno(paragraphs: 2, words: 20),
        hint = ameno(paragraphs: 1, words: 10),
        solution = ameno(paragraphs: 1, words: 20),
        uuid = const Uuid().v4obj(),
        solutions = [];

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      hint.hashCode ^
      solution.hashCode ^
      uuid.hashCode ^
      solutions.hashCode;

  String get mostRecentSummary {
    if (solutions.isNotEmpty) {
      return solutions.min().formatted();
    }
    return 'Not answered yet';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          hint == other.hint &&
          solution == other.solution &&
          uuid == other.uuid &&
          solutions.equals(other.solutions);

  @override
  String toString() {
    return 'Task{title: $title, description: $description, hint: $hint, solution: $solution, uuid: $uuid, solutions: $solutions}';
  }

  Map<String, dynamic> toMap() {
    return {
      uuidKey: uuid.toString(),
      titleKey: title,
      descriptionKey: description,
      hintKey: hint,
      solutionKey: solution,
      solutionsKey: solutions.map((e) => e.toMap()).toList(),
    };
  }

  static Task? fromMap(Map map) {
    try {
      final title = map[titleKey] as String;
      final uuid = map.transformOrFallback<UuidValue>(
        uuidKey,
        (value) => UuidValue(value),
        const Uuid().v4obj(),
      );
      final description = map[descriptionKey] as String;
      final hint = map[hintKey] as String;
      final solution = map[solutionKey] as String;
      final solutions = List<Map>.from(map[solutionsKey] ?? [])
          .map((e) => SolutionState.fromMap(e))
          .whereType<SolutionState>()
          .toList();

      return Task(
        title,
        description,
        hint,
        solution,
        solutions: solutions,
        uuid: uuid,
      );
    } catch (e) {
      log(
        'Failed to create Task, error: ${e.toString()}',
        name: 'Task.fromMap',
      );
    }
    return null;
  }
}
