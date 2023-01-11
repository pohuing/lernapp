import 'package:hive/hive.dart';
import 'package:lernapp/model/color_pair.dart';
import 'package:lernapp/repositories/task_repository.dart';

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
}

class GeneralPreferencesChanged extends PreferencesStateBase {
  GeneralPreferencesChanged(
    super.repositorySettings,
    super.themePreferences,
    super.generalPreferences,
  );
}

class HiveRepositoryConfiguration implements RepositoryConfigurationBase {
  static const String boxNameKey = 'boxName';
  final String boxName;

  HiveRepositoryConfiguration(this.boxName);

  @override
  String get title => 'Hive name: $boxName';

  @override
  Future<TaskRepositoryBase> createRepository() async {
    return HiveTaskRepository(box: await Hive.openBox(boxName));
  }

  @override
  RepositoryConfigurationBase? fromMap(Map<String, dynamic> map) {
    if (map.containsKey(boxNameKey)) {
      return HiveRepositoryConfiguration(map[boxNameKey]);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      boxNameKey: boxName,
    };
  }
}

class PreferencesStateBase {
  final RepositorySettings repositorySettings;
  final ThemePreferences themePreferences;
  final GeneralPreferences generalPreferences;

  PreferencesStateBase(
    this.repositorySettings,
    this.themePreferences, [
    GeneralPreferences? generalPreferences,
  ]) : generalPreferences = generalPreferences ?? const GeneralPreferences();

  Map<String, dynamic> toMap() {
    return {
      'repositorySettings': repositorySettings.toMap(),
      'themePreferences': themePreferences.toMap(),
      'generalPreferences': generalPreferences.toMap(),
    };
  }

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

abstract class RepositoryConfigurationBase {
  String get title;

  Future<TaskRepositoryBase> createRepository();

  RepositoryConfigurationBase? fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();
}

class RepositoryConfigurationChanged extends PreferencesStateBase {
  RepositoryConfigurationChanged(
    super.repositorySettings,
    super.themePreferences,
    super.generalPreferences,
  );
}

class RepositorySettings {
  final List<RepositoryConfigurationBase> configurations;
  RepositoryConfigurationBase? currentConfiguration;

  RepositorySettings(this.configurations, this.currentConfiguration);

  Map<String, dynamic> toMap() {
    return {
      'configurations':
          configurations.map((e) => e.toMap()).toList(growable: false),
    };
  }
}

class ThemeChanged extends PreferencesStateBase {
  ThemeChanged(
    super.repositorySettings,
    super.themePreferences,
    super.generalPreferences,
  );
}

class ThemePreferences {
  static const String paintAAKey = 'paintAA';
  static const String blendAAKey = 'blendAA';
  static const String correctionColorsKey = 'correctionColors';

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

  Map<String, dynamic> toMap() {
    return {
      paintAAKey: paintAA,
      blendAAKey: blendAA,
      correctionColorsKey: correctionColors.toMap(),
    };
  }
}
