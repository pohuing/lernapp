import 'base.dart';

class RepositorySettings {
  static const configurationKey = 'configurations';
  final List<RepositoryConfigurationBase> configurations;

  RepositoryConfigurationBase? currentConfiguration;

  RepositorySettings(this.configurations, this.currentConfiguration);

  Map<String, dynamic> toMap() {
    return {
      configurationKey:
          configurations.map((e) => e.toMap()).toList(growable: false),
    };
  }

  static RepositorySettings? fromMap(Map map) {
    if (map.containsKey(configurationKey)) {
      final parsed = List<Map<String, dynamic>>.of(map[configurationKey]);
      final converted =
          parsed.map((e) => RepositoryConfigurationBase.fromMap(e)).toList();
    }
  }
}
