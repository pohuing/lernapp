import 'package:hive/hive.dart';
import 'package:lernapp/repositories/task_repository.dart';

import 'base.dart';

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
    if (canDeserialize(map)) {
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

  static bool canDeserialize(Map<String, dynamic> map) {
    return map.containsKey(boxNameKey) &&
        map[boxNameKey] is String &&
        map[boxNameKey].length >= 1;
  }
}
