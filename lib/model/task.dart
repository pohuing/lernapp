import 'package:collection/collection.dart';
import 'package:flutter_ameno_ipsum/flutter_ameno_ipsum.dart';
import 'package:uuid/uuid.dart';

import 'line.dart';

class Task {
  static const uuidKey = 'uuid';
  static const linesKey = 'lines';
  static const solutionKey = 'solution';
  static const hintKey = 'hint';
  static const descriptionKey = 'description';
  static const titleKey = 'title';

  String title;
  String description;
  String hint;
  String solution;
  UuidValue uuid;
  List<Line> drawnLines;

  Task(
    this.title,
    this.description,
    this.hint,
    this.solution, {
    List<Line>? drawnLines,
    UuidValue? uuid,
  })  : drawnLines = drawnLines ?? [],
        uuid = uuid ?? const Uuid().v4obj();

  Task.lorem()
      : title = ameno(paragraphs: 1, words: 4),
        description = ameno(paragraphs: 2, words: 20),
        hint = ameno(paragraphs: 1, words: 10),
        solution = ameno(paragraphs: 1, words: 20),
        uuid = const Uuid().v4obj(),
        drawnLines = [];

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
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
          description == other.description &&
          hint == other.hint &&
          solution == other.solution &&
          uuid == other.uuid &&
          drawnLines.equals(other.drawnLines);

  @override
  String toString() {
    return 'Task{title: $title, description: $description, hint: $hint, solution: $solution, uuid: $uuid, drawnLines: $drawnLines}';
  }

  Map<String, dynamic> toMap() {
    return {
      uuidKey: uuid.toString(),
      titleKey: title,
      descriptionKey: description,
      hintKey: hint,
      solutionKey: solution,
      linesKey: drawnLines.map((e) => e.toMap()).toList()
    };
  }

  static Task? fromMap(Map<String, dynamic> map) {
    try {
      final title = map[titleKey] as String;
      final uuid = UuidValue(map[uuidKey]);
      final description = map[descriptionKey] as String;
      final hint = map[hintKey] as String;
      final solution = map[solutionKey] as String;
      final lines = List<Map<String, dynamic>>.from(map[linesKey])
          .map((e) => Line.fromMap(e))
          .whereType<Line>()
          .toList();

      return Task(
        title,
        description,
        hint,
        solution,
        drawnLines: lines,
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
