class GeneralPreferences {
  static const String showHistoryBeforeSolvingKey = 'showHistory';
  final bool showHistoryBeforeSolving;

  const GeneralPreferences([bool? showHistoryBeforeSolving])
      : showHistoryBeforeSolving = showHistoryBeforeSolving ?? false;

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

  static GeneralPreferences? fromMap(generalPrefsVal) {
    throw UnimplementedError();
  }
}
