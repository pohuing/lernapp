import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/logic/logging.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class PreferencesBloc extends Bloc<PreferencesEventBase, PreferencesStateBase> {
  StreamSubscription<PreferencesStateBase>? _loggingSubscription;

  PreferencesBloc(super.initialState) {
    on<ChangeRepositoryConfiguration>(onChangeRepository);
    on<ChangePaintAA>(_onPaintAAChange);
    on<ChangeBlendAA>(_onChangeBlendAA);
    _loggingSubscription = stream
        .listen((event) => log(event.toString(), name: 'PreferencesBloc'));
  }

  void _onChangeBlendAA(event, emit) {
    emit(
      ThemeChanged(
        state.repositorySettings,
        state.themePreferences.copyWith(
          blendAA: event.newValue,
        ),
      ),
    );
  }

  void _onPaintAAChange(event, emit) {
    emit(
      ThemeChanged(
        state.repositorySettings,
        state.themePreferences.copyWith(
          paintAA: event.newValue,
        ),
      ),
    );
  }

  void onChangeRepository(event, emit) {
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
