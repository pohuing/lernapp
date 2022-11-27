import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/repositories/task_repository.dart';

import 'events.dart';

class PreferencesBloc extends Bloc<PreferencesEventBase, PreferencesStateBase> {
  StreamSubscription<PreferencesStateBase>? _loggingSubscription;

  PreferencesBloc(super.initialState) {
    on<ChangeRepositoryConfiguration>(onChangeRepository);
    _loggingSubscription = stream
        .listen((event) => log(event.toString(), name: 'PreferencesBloc'));
  }

  FutureOr<void> onChangeRepository(event, emit) {
    emit(
      RepositoryConfigurationChanged(
        RepositorySettings(
          state.repositorySettings.configurations,
          event.configuration,
        ),
        state.themePreferences,
      ),
    );
  }

  void dispose(){
    _loggingSubscription?.cancel();
  }
}

class RepositoryConfigurationChanged implements PreferencesStateBase {
  @override
  final RepositorySettings repositorySettings;

  @override
  final ThemePreferences themePreferences;

  RepositoryConfigurationChanged(
    this.repositorySettings,
    this.themePreferences,
  );
}

class PreferencesStateBase {
  final RepositorySettings repositorySettings;
  final ThemePreferences themePreferences;

  PreferencesStateBase(this.repositorySettings, this.themePreferences);
}

class RepositorySettings {
  final List<RepositoryConfigurationBase> configurations;
  RepositoryConfigurationBase? currentConfiguration;

  RepositorySettings(this.configurations, this.currentConfiguration);
}

abstract class RepositoryConfigurationBase {
  Future<TaskRepositoryBase> createRepository();

  String get title;
}

class HiveRepositoryConfiguration implements RepositoryConfigurationBase {
  final String boxName;

  HiveRepositoryConfiguration(this.boxName);

  @override
  Future<TaskRepositoryBase> createRepository() async {
    return HiveTaskRepository(box: await Hive.openBox(boxName));
  }

  @override
  String get title => 'Hive name: $boxName';
}

class ThemePreferences {}
