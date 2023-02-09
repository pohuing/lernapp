/// Dataclass for storing general preferences about the behaviour of the
/// Application
class GeneralPreferences {
  static const String showHistoryBeforeSolvingKey = 'showHistory';

  /// Whether to show the history button in the [TaskScreen] before revealing
  /// the solution
  final bool showHistoryBeforeSolving;
  static const bool defaultShowHistoryBeforeSolving = false;

  const GeneralPreferences([bool? showHistoryBeforeSolving])
      : showHistoryBeforeSolving =
            showHistoryBeforeSolving ?? defaultShowHistoryBeforeSolving;

  GeneralPreferences copyWith({bool? showHistoryBeforeSolving}) {
    return GeneralPreferences(
      showHistoryBeforeSolving ?? this.showHistoryBeforeSolving,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      showHistoryBeforeSolvingKey: showHistoryBeforeSolving,
    };
  }

  static GeneralPreferences? fromMap(Map map) {
    final showHistoryBeforeSolving = _extractShowHistoryBeforeSolving(map);

    return GeneralPreferences(
      showHistoryBeforeSolving ?? defaultShowHistoryBeforeSolving,
    );
  }

  static bool? _extractShowHistoryBeforeSolving(Map map) {
    return map[showHistoryBeforeSolvingKey];
  }
}
