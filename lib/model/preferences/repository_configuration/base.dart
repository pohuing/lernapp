import 'package:lernapp/repositories/task_repository.dart';

import 'hive_repository_configuration.dart';

/// The base class for configurations for Repositories
///
/// All Subclasses should implement a [fromMap] function and add their
/// check to [RepositoryConfigurationBase.fromMap]
abstract class RepositoryConfigurationBase {
  /// User facing title for this configuration
  String get title;

  /// Create a new [TaskRepositoryBase] from this configuration
  Future<TaskRepositoryBase> createRepository();

  Map<String, dynamic> toMap();

  /// Construct an instance from [map], returns null if there is no Configuration
  /// That successfully deserialized [map] into an instance
  static RepositoryConfigurationBase? fromMap(Map<String, dynamic> map) {
    if (HiveRepositoryConfiguration.canDeserialize(map)) {
      final hrc = HiveRepositoryConfiguration.fromMap(map);
      if (hrc != null) {
        return hrc;
      }
    }

    return null;
  }
}
