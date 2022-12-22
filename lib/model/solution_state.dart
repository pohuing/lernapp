import 'package:collection/collection.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:uuid/uuid.dart';

import 'line.dart';

class SolutionState {
  final UuidValue id;
  final List<Line> lines;
  final DateTime timestamp;
  final bool revealedSolution;
  static const _uuidGenerator = Uuid();

  static const idKey = 'id';
  static const linesKey = 'lines';
  static const timestampKey = 'timestamp';
  static const revealedSolutionKey = 'revealed';

  SolutionState(
    this.lines, {
    bool? revealedSolution,
    UuidValue? id,
    DateTime? timestamp,
  })  : id = id ?? _uuidGenerator.v4obj(),
        revealedSolution = revealedSolution ?? false,
        timestamp = timestamp ?? DateTime.now();

  static SolutionState? fromMap(Map map) {
    try {
      final id = UuidValue(map[idKey]);
      final timestamp = DateTime.parse(map[timestampKey]);
      final lines = List<Map>.from(map[linesKey])
          .map((e) => Line.fromMap(e))
          .whereType<Line>()
          .toList();
      final revealed = map[revealedSolutionKey];

      return SolutionState(
        lines,
        id: id,
        timestamp: timestamp,
        revealedSolution: revealed,
      );
    } catch (e) {
      log(
        'Failed to create SolutionState, error ${e.toString()}',
        name: 'SolutionState.fromMap()',
      );
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id.uuid,
      timestampKey: timestamp.toIso8601String(),
      linesKey: lines.map((e) => e.toMap()).toList(),
      revealedSolutionKey: revealedSolution,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SolutionState &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          timestamp == other.timestamp &&
          lines.equals(other.lines) &&
          revealedSolution == other.revealedSolution;

  @override
  int get hashCode =>
      id.hashCode ^
      lines.fold(
        0,
        (previousValue, element) => previousValue ^ element.hashCode,
      ) ^
      timestamp.hashCode ^
      (revealedSolution ? 1 : 0);
}
