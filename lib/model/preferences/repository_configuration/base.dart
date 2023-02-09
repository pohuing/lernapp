import 'package:lernapp/repositories/task_repository.dart';

import 'hive_repository_configuration.dart';

abstract class RepositoryConfigurationBase {
  String get title;

  Future<TaskRepositoryBase> createRepository();

  Map<String, dynamic> toMap();

  static RepositoryConfigurationBase? fromMap(Map<String, dynamic> map) {
    if (HiveRepositoryConfiguration.canDeserialize(map)) {}
  }
}
