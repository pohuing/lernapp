import 'package:lernapp/logic/nullable_extensions.dart';
import 'package:lernapp/model/preferences/general_preferences.dart';
import 'package:lernapp/model/preferences/repository_configuration/hive_repository_configuration.dart';
import 'package:lernapp/model/preferences/repository_configuration/repository_settings.dart';
import 'package:lernapp/model/preferences/theme_preferences.dart';

class GeneralPreferencesChanged extends PreferencesStateBase {
  GeneralPreferencesChanged(
    super.repositorySettings,
    super.themePreferences,
    super.generalPreferences,
  );
}

class PreferencesStateBase {
  static const repositorySettingsKey = 'repositorySettings';
  static const themePreferencesKey = 'themePreferences';
  static const generalPreferencesKey = 'generalPreferences';

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
      repositorySettingsKey: repositorySettings.toMap(),
      themePreferencesKey: themePreferences.toMap(),
      generalPreferencesKey: generalPreferences.toMap(),
    };
  }

  static PreferencesStateBase fromMap(Map map) {
    late final RepositorySettings repositorySettings;
    late final ThemePreferences themePreferences;
    late final GeneralPreferences generalPreferences;
    if (map.containsKey(repositorySettingsKey)) {
      repositorySettings =
          RepositorySettings.fromMap(map[repositorySettingsKey])
              .constructDefault(constructFallbackRepoSettings);
    } else {
      repositorySettings = constructFallbackRepoSettings();
    }
    if (map.containsKey(themePreferencesKey)) {
      themePreferences = ThemePreferences.fromMap(map[themePreferencesKey]) ??
          ThemePreferences.defaults();
    } else {
      themePreferences = ThemePreferences.defaults();
    }
    if (map.containsKey(generalPreferencesKey)) {
      generalPreferences =
          GeneralPreferences.fromMap(map[generalPreferencesKey]) ??
              const GeneralPreferences();
    } else {
      generalPreferences = const GeneralPreferences();
    }

    return PreferencesStateBase(
      repositorySettings,
      themePreferences,
      generalPreferences,
    );
  }

  static RepositorySettings constructFallbackRepoSettings() {
    final hiveConfig = HiveRepositoryConfiguration('tcbox');
    return RepositorySettings([hiveConfig], hiveConfig);
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
