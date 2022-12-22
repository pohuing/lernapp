import 'package:hive/hive.dart';
import 'package:lernapp/model/color_pair.dart';
import 'package:lernapp/repositories/task_repository.dart';

class RepositoryConfigurationChanged extends PreferencesStateBase {
  RepositoryConfigurationChanged(
    super.repositorySettings,
    super.themePreferences,
    super.generalPreferences,
  );
}

class ThemeChanged extends PreferencesStateBase {
  ThemeChanged(
    super.repositorySettings,
    super.themePreferences,
    super.generalPreferences,
  );
}

class GeneralPreferencesChanged extends PreferencesStateBase {
  GeneralPreferencesChanged(
    super.repositorySettings,
    super.themePreferences,
    super.generalPreferences,
  );
}

class PreferencesStateBase {
  final RepositorySettings repositorySettings;
  final ThemePreferences themePreferences;
  final GeneralPreferences generalPreferences;

  PreferencesStateBase(
    this.repositorySettings,
    this.themePreferences, [
    GeneralPreferences? generalPreferences,
  ]) : generalPreferences = generalPreferences ?? GeneralPreferences();

  static PreferencesStateBase construct(
    RepositorySettings repositorySettings,
    ThemePreferences themePreferences,
    GeneralPreferences generalPreferences,
  ) {
    return PreferencesStateBase(
      repositorySettings,
      themePreferences,
      generalPreferences,
    );
  }

// TODO introduce generic copyWith once dart is powerful enough for it
//T copyWith<T extends PreferencesStateBase>({
//  RepositorySettings? repositorySettings,
//  ThemePreferences? themePreferences,
//  GeneralPreferences? generalPreferences,
//}) {
//  return T.construct(
//    repositorySettings,
//    themePreferences,
//    generalPreferences,
//  );
//}
}

class RepositorySettings {
  final List<RepositoryConfigurationBase> configurations;
  RepositoryConfigurationBase? currentConfiguration;

  RepositorySettings(this.configurations, this.currentConfiguration);
}

abstract class RepositoryConfigurationBase {
  Future<TaskRepositoryBase> createRepository();

  String get title;
}

class HiveRepositoryConfiguration implements RepositoryConfigurationBase {
  final String boxName;

  HiveRepositoryConfiguration(this.boxName);

  @override
  Future<TaskRepositoryBase> createRepository() async {
    return HiveTaskRepository(box: await Hive.openBox(boxName));
  }

  @override
  String get title => 'Hive name: $boxName';
}

class ThemePreferences {
  final bool paintAA;
  final bool blendAA;
  final ColorPair correctionColors;

  ThemePreferences(this.paintAA, this.blendAA, ColorPair? correctionColors)
      : correctionColors = correctionColors ?? ColorPair.correctionColors;

  ThemePreferences.defaults()
      : paintAA = false,
        blendAA = false,
        correctionColors = ColorPair.correctionColors;

  ThemePreferences copyWith({
    bool? paintAA,
    bool? blendAA,
    ColorPair? correctionColors,
  }) {
    return ThemePreferences(
      paintAA ?? this.paintAA,
      blendAA ?? this.blendAA,
      correctionColors ?? this.correctionColors,
    );
  }
}

class GeneralPreferences {
  final bool showHistoryBeforeSolving;

  const GeneralPreferences([bool? showHistoryBeforeSolving])
      : showHistoryBeforeSolving = showHistoryBeforeSolving ?? false;

  GeneralPreferences copyWith({bool? showHistoryBeforeSolving}) {
    return GeneralPreferences(
      showHistoryBeforeSolving ?? this.showHistoryBeforeSolving,
    );
  }
}
