import 'package:collection/collection.dart';
import 'package:flutter_ameno_ipsum/flutter_ameno_ipsum.dart';
import 'package:lernapp/logic/list_extensions.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/logic/map_extensions.dart';
import 'package:lernapp/model/solution_state.dart';
import 'package:uuid/uuid.dart';

class Task {
  static const uuidKey = 'uuid';
  static const solutionTitleKey = 'solutionTitle';
  static const solutionBodyKey = 'solutionBody';
  static const taskBodyKey = 'taskBody';
  static const taskTitleKey = 'taskTitle';
  static const solutionsKey = 'solutions';

  String taskTitle;
  String taskBody;
  String solutionBody;
  String solutionTitle;
  UuidValue uuid;
  List<SolutionState> solutions;

  Task(
    this.taskTitle,
    this.taskBody,
    this.solutionBody,
    this.solutionTitle, {
    UuidValue? uuid,
    List<SolutionState>? solutions,
  })  : solutions = solutions ?? [],
        uuid = uuid ?? const Uuid().v4obj();

  Task.lorem()
      : taskTitle = ameno(paragraphs: 1, words: 4),
        taskBody = ameno(paragraphs: 2, words: 20),
        solutionBody = ameno(paragraphs: 1, words: 10),
        solutionTitle = ameno(paragraphs: 1, words: 20),
        uuid = const Uuid().v4obj(),
        solutions = [];

  @override
  int get hashCode =>
      taskTitle.hashCode ^
      taskBody.hashCode ^
      solutionBody.hashCode ^
      solutionTitle.hashCode ^
      uuid.hashCode ^
      solutions.hashCode;

  String get mostRecentSummary {
    if (solutions.isNotEmpty) {
      return solutions.max().formatted();
    }
    return 'Not answered yet';
  }

  SolutionState? get mostRecentSolution {
    if (solutions.isNotEmpty) {
      return solutions.max();
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          taskTitle == other.taskTitle &&
          taskBody == other.taskBody &&
          solutionBody == other.solutionBody &&
          solutionTitle == other.solutionTitle &&
          uuid == other.uuid &&
          solutions.equals(other.solutions);

  @override
  String toString() {
    return 'Task{title: $taskTitle, description: $taskBody, hint: $solutionBody, solution: $solutionTitle, uuid: $uuid, solutions: $solutions}';
  }

  Map<String, dynamic> toMap() {
    return {
      uuidKey: uuid.toString(),
      taskTitleKey: taskTitle,
      taskBodyKey: taskBody,
      solutionBodyKey: solutionBody,
      solutionTitleKey: solutionTitle,
      solutionsKey: solutions.map((e) => e.toMap()).toList(),
    };
  }

  static Task? fromMap(Map map) {
    try {
      final title = map[taskTitleKey] as String;
      final uuid = map.transformOrFallback<UuidValue>(
        uuidKey,
        (value) => UuidValue(value),
        const Uuid().v4obj(),
      );
      final description = map[taskBodyKey] as String;
      final hint = map[solutionBodyKey] as String;
      final solution = map[solutionTitleKey] as String;
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
