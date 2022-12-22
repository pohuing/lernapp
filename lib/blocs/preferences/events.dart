import 'package:lernapp/blocs/preferences/states.dart';
import 'package:lernapp/model/color_pair.dart';

abstract class PreferencesEventBase {}

class ChangeRepositoryConfiguration implements PreferencesEventBase {
  final RepositoryConfigurationBase configuration;

  ChangeRepositoryConfiguration(this.configuration);
}

class AddRepositoryConfiguration implements PreferencesEventBase {
  final RepositoryConfigurationBase newConfiguration;

  AddRepositoryConfiguration(this.newConfiguration);
}

class ChangeBlendAA implements PreferencesEventBase {
  final bool newValue;

  ChangeBlendAA(this.newValue);
}

class ChangePaintAA implements PreferencesEventBase {
  final bool newValue;

  ChangePaintAA(this.newValue);
}

class ChangeCorrectionColor implements PreferencesEventBase {
  final ColorPair newColors;

  ChangeCorrectionColor(this.newColors);
}

class ChangeShowHistory implements PreferencesEventBase {
  final bool showHistory;

  ChangeShowHistory(this.showHistory);
}
