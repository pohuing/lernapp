import 'package:hive/hive.dart';
import 'package:lernapp/repositories/task_repository.dart';

class RepositoryConfigurationChanged implements PreferencesStateBase {
  @override
  final RepositorySettings repositorySettings;

  @override
  final ThemePreferences themePreferences;

  RepositoryConfigurationChanged(
    this.repositorySettings,
    this.themePreferences,
  );
}

class ThemeChanged implements PreferencesStateBase {
  @override
  final RepositorySettings repositorySettings;

  @override
  final ThemePreferences themePreferences;

  ThemeChanged(this.repositorySettings, this.themePreferences);
}

class PreferencesStateBase {
  final RepositorySettings repositorySettings;
  final ThemePreferences themePreferences;

  PreferencesStateBase(this.repositorySettings, this.themePreferences);
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

  ThemePreferences(this.paintAA, this.blendAA);

  ThemePreferences copyWith({bool? paintAA, bool? blendAA}) {
    return ThemePreferences(paintAA ?? this.paintAA, blendAA ?? this.blendAA);
  }
}
