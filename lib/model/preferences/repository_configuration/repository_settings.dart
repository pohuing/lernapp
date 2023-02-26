import 'package:lernapp/logic/logging.dart';

import 'base.dart';

class RepositorySettings {
  static const configurationsKey = 'configurations';
  static const currentConfigurationIndexKey = 'currentConfigurationIndexKey';

  final List<RepositoryConfigurationBase> configurations;
  RepositoryConfigurationBase? currentConfiguration;

  int? get configurationIndex {
    if (currentConfiguration == null) {
      return null;
    }
    if (!configurations.contains(currentConfiguration)) {
      return null;
    }
    return configurations.indexOf(currentConfiguration!);
  }

  RepositorySettings(this.configurations, this.currentConfiguration);

  Map<String, dynamic> toMap() {
    return {
      configurationsKey:
          configurations.map((e) => e.toMap()).toList(growable: false),
      currentConfigurationIndexKey: configurationIndex,
    };
  }

  static RepositorySettings? fromMap(Map map) {
    final index = _extractIndex(map);
    final configurations = _extractConfigurations(map);
    if (configurations == null || configurations.isEmpty) {
      return null;
    }
    final currentConfiguration =
        _extractCurrentConfiguration(index, configurations);

    return RepositorySettings(configurations, currentConfiguration);
  }

  static RepositoryConfigurationBase? _extractCurrentConfiguration(
    int? index,
    List<RepositoryConfigurationBase> configurations,
  ) {
    if (index == null || configurations.length < index) {
      return null;
    }
    return configurations[index];
  }

  static int? _extractIndex(Map map) {
    if (map.containsKey(currentConfigurationIndexKey)) {
      try {
        final index = map[currentConfigurationIndexKey] as int;
        if (index < 0) {
          return null;
        }
        return index;
      } catch (e) {
        log(e.toString());
      }
    }
    return null;
  }

  static List<RepositoryConfigurationBase>? _extractConfigurations(Map map) {
    if (!map.containsKey(configurationsKey)) {
      log(
        'Missing configurationsKey in map',
        name: 'RepositorySettings.fromMap',
      );
      return null;
    }

    try {
      final parsed = List<Map<String, dynamic>>.of(map[configurationsKey]);
      final converted = parsed
          .map((e) => RepositoryConfigurationBase.fromMap(e))
          .whereType<RepositoryConfigurationBase>()
          .toList();

      return converted;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
