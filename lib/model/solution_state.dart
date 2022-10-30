import 'package:collection/collection.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:uuid/uuid.dart';

import 'line.dart';

class SolutionState {
  final UuidValue id;
  final List<Line> lines;
  final DateTime timestamp;
  static const _uuidGenerator = Uuid();

  static const idKey = 'id';
  static const linesKey = 'lines';
  static const timestampKey = 'timestamp';

  SolutionState(this.lines, {UuidValue? id, DateTime? timestamp})
      : id = id ?? _uuidGenerator.v4obj(),
        timestamp = timestamp ?? DateTime.now();

  static SolutionState? fromMap(Map<String, dynamic> map) {
    try {
      final id = UuidValue(map[idKey]);
      final timestamp = DateTime.parse(map[timestampKey]);
      final lines = List<Map<String, dynamic>>.from(map[linesKey])
          .map((e) => Line.fromMap(e))
          .whereType<Line>()
          .toList();

      return SolutionState(lines, id: id, timestamp: timestamp);
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
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SolutionState &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          timestamp == other.timestamp &&
          lines.equals(other.lines);

  @override
  int get hashCode => id.hashCode ^ lines.hashCode ^ timestamp.hashCode;
}
