import 'package:lernapp/blocs/preferences/preferences_bloc.dart';

abstract class PreferencesEventBase {}

class ChangeRepositoryConfiguration implements PreferencesEventBase{
  final RepositoryConfigurationBase configuration;

  ChangeRepositoryConfiguration(this.configuration);
}

class AddRepositoryConfiguration implements PreferencesEventBase{
  final RepositoryConfigurationBase newConfiguration;

  AddRepositoryConfiguration(this.newConfiguration);
}