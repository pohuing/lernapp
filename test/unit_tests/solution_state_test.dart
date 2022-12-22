import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/model/line.dart';
import 'package:lernapp/model/solution_state.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('SolutionState', () {
    test('serialize SolutionState', () {
      final original = SolutionState([
        Line.withDefaultProperties([Offset.zero]),
      ]);
      final serialized = original.toMap();

      expect(serialized[SolutionState.idKey], original.id.uuid);
      expect(
        serialized[SolutionState.linesKey],
        containsAllInOrder(original.lines.map((e) => e.toMap()).toList()),
      );
      expect(
        DateTime.parse(serialized[SolutionState.timestampKey]),
        original.timestamp,
      );
      expect(serialized[SolutionState.revealedSolutionKey], false);
    });

    test('deserialize SolutionState', () {
      final originalId = const Uuid().v4obj();
      final originalTimestamp = DateTime.now();
      final originalLines = [
        Line.withDefaultProperties([Offset.zero]),
        Line.withDefaultProperties([Offset.zero]),
      ];
      const originalRevealedSolution = true;

      final original = {
        SolutionState.idKey: originalId.uuid,
        SolutionState.timestampKey: originalTimestamp.toIso8601String(),
        SolutionState.linesKey: originalLines.map((e) => e.toMap()).toList(),
        SolutionState.revealedSolutionKey: originalRevealedSolution,
      };

      final deserialized = SolutionState.fromMap(original)!;

      expect(deserialized.id, originalId);
      expect(deserialized.timestamp, originalTimestamp);
      expect(deserialized.lines, originalLines);
      expect(deserialized.revealedSolution, originalRevealedSolution);
    });

    test('back and forth SolutionState', () {
      final original = SolutionState([
        Line.withDefaultProperties([const Offset(0, 1)])
      ]);

      final serialized = original.toMap();
      final deserialized = SolutionState.fromMap(serialized);

      expect(deserialized, original);
      expect(deserialized.hashCode, original.hashCode);
    });
  });
}
