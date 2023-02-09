import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/model/preferences/repository_configuration/repository_settings.dart';

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
    on<ChangeCorrectionColor>(_onChangeCorrectionColor);
    on<ChangeShowHistory>(_onChangeShowHistory);
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
        state.generalPreferences,
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
        state.generalPreferences,
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
        state.generalPreferences,
      ),
    );
  }

  void dispose() {
    _loggingSubscription?.cancel();
  }

  void _onChangeCorrectionColor(
    ChangeCorrectionColor event,
    Emitter<PreferencesStateBase> emit,
  ) {
    emit(
      ThemeChanged(
        state.repositorySettings,
        state.themePreferences.copyWith(correctionColors: event.newColors),
        state.generalPreferences,
      ),
    );
  }

  _onChangeShowHistory(
    ChangeShowHistory event,
    Emitter<PreferencesStateBase> emit,
  ) {
    emit(
      GeneralPreferencesChanged(
        state.repositorySettings,
        state.themePreferences,
        state.generalPreferences
            .copyWith(showHistoryBeforeSolving: event.showHistory),
      ),
    );
  }
}
