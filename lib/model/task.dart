import 'package:flutter_ameno_ipsum/flutter_ameno_ipsum.dart';
import 'package:uuid/uuid.dart';

import 'line.dart';

class Task {
  String title;
  String taskDescription;
  String hint;
  String solution;
  UuidValue uuid;
  List<Line> drawnLines;

  Task(
    this.title,
    this.taskDescription,
    this.hint,
    this.solution, {
    List<Line>? drawnLines,
    UuidValue? uuid,
  })  : drawnLines = drawnLines ?? [],
        uuid = uuid ?? const Uuid().v4obj();

  Task.lorem()
      : title = ameno(paragraphs: 1, words: 4),
        taskDescription = ameno(paragraphs: 2, words: 20),
        hint = ameno(paragraphs: 1, words: 10),
        solution = ameno(paragraphs: 1, words: 20),
        uuid = const Uuid().v4obj(),
        drawnLines = [];

  @override
  int get hashCode =>
      title.hashCode ^
      taskDescription.hashCode ^
      hint.hashCode ^
      solution.hashCode ^
      uuid.hashCode ^
      drawnLines.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          taskDescription == other.taskDescription &&
          hint == other.hint &&
          solution == other.solution &&
          uuid == other.uuid &&
          drawnLines == other.drawnLines;

  @override
  String toString() {
    return 'Task{title: $title, taskDescription: $taskDescription, hint: $hint, solution: $solution, uuid: $uuid, drawnLines: $drawnLines}';
  }
}
