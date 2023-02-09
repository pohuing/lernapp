import 'package:hive/hive.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/logic/logging.dart';

class PreferencesRepository {
  Box box;
  final String boxName = 'preferences';

  PreferencesRepository(this.box);

  static Future<PreferencesRepository> openBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    return PreferencesRepository(box);
  }

  PreferencesStateBase loadPreferences() {
    log('Loading preferences', name: 'PreferencesRepository.loadPreferences');
    final root = box.toMap();
    late final Map map;
    if (root.containsKey(0)) {
      map = root[0];
    } else {
      //use fallback from [PreferencesStateBase] by passing empty map
      map = {};
    }
    return PreferencesStateBase.fromMap(map);
  }

  Future<void> storePreferences(PreferencesStateBase prefs) async {
    log('Saving preferences', name: 'PreferencesRepository.storePreferences');
    await box.clear();
    await box.add(prefs.toMap());
  }
}
