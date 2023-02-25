import 'package:lernapp/model/color_pair.dart';
import 'package:lernapp/model/preferences/repository_configuration/base.dart';

class AddRepositoryConfiguration implements PreferencesEventBase {
  final RepositoryConfigurationBase newConfiguration;

  AddRepositoryConfiguration(this.newConfiguration);
}

class ChangeBlendAA implements PreferencesEventBase {
  final bool newValue;

  ChangeBlendAA(this.newValue);
}

class ChangeCorrectionColor implements PreferencesEventBase {
  final ColorPair newColors;

  ChangeCorrectionColor(this.newColors);
}

class ChangePaintAA implements PreferencesEventBase {
  final bool newValue;

  ChangePaintAA(this.newValue);
}

class ChangeLineWidth implements PreferencesEventBase {
  final double newWidth;

  ChangeLineWidth(this.newWidth);
}

class ChangeRepositoryConfiguration implements PreferencesEventBase {
  final RepositoryConfigurationBase configuration;

  ChangeRepositoryConfiguration(this.configuration);
}

class ChangeShowHistory implements PreferencesEventBase {
  final bool showHistory;

  ChangeShowHistory(this.showHistory);
}

abstract class PreferencesEventBase {}
