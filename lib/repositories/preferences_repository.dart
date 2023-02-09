import 'package:hive/hive.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';

class PreferencesRepository {
  Box box;
  final String boxName = 'preferences';

  PreferencesRepository(this.box);

  factory() async {
    final box = await Hive.openBox(boxName);
    return PreferencesRepository(box);
  }

  PreferencesStateBase loadPreferences() {
    return PreferencesStateBase.fromMap(box.toMap());
  }

  Future<void> storePreferences(PreferencesStateBase prefs) async {
    await box.clear();
    await box.add(prefs.toMap());
  }
}
