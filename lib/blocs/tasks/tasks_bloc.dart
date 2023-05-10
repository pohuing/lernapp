import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/repositories/task_repository.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class TasksBloc extends Bloc<TaskStorageEventBase, TaskStorageStateBase> {
  TaskRepositoryBase repository;
  PreferencesBloc preferencesBloc;
  StreamSubscription<PreferencesStateBase>? _listen;
  StreamSubscription<TaskStorageStateBase>? _loggingSubscription;

  TasksBloc(this.repository, this.preferencesBloc)
      : super(TaskStorageUninitialized()) {
    on<TaskStorageLoad>(_onLoad);
    on<TaskStorageSave>(_onSave);
    on<TaskStorageWipe>(_onWipe);
    on<TaskStorageSaveCategory>(_onSaveCategory);
    on<TaskStorageSaveTask>(_onSaveTask);
    on<TaskStorageChanged>(_onStorageChanged);
    on<TaskStorageImportCategories>(_onImport);
    on<TaskStorageMoveTask>(_onTaskStorageMove);

    _loggingSubscription =
        stream.listen((event) => log(event.toString(), name: 'TasksBloc'));

    _listen = preferencesBloc.stream.listen((event) async {
      if (event is RepositoryConfigurationChanged) {
        var newRepository = await event.repositorySettings.currentConfiguration
            ?.createRepository();
        if (newRepository != null) {
          add(TaskStorageChanged(newRepository));
          return;
        }
        log(
          'Failed setting new Task storage. Incoming event: ${event.toString()}',
          name: 'TasksBloc',
        );
      }
    });
  }

  Future<void> _onTaskStorageMove(
    TaskStorageMoveTask event,
    Emitter<TaskStorageStateBase> emit,
  ) async {
    await repository.moveTask(event.task, event.to);
    await _onSave(event, emit);
    emit(TaskStorageDataChanged(repository.categories));
  }

  Future<void> _onImport(event, emit) async {
    emit(TaskStorageUninitialized());
    await repository.wipeStorage();
    await repository.import(event.newCategories);
    emit(TaskStorageLoaded(repository.categories));
  }

  @override
  void onEvent(TaskStorageEventBase event) {
    super.onEvent(event);
    log('New event: ${event.toString()}', name: 'TasksBloc');
  }

  Future<void> _onStorageChanged(event, emit) async {
    repository = event.newRepository;
    emit(TaskStorageLoading());
    await repository.reload();
    emit(TaskStorageLoaded(repository.categories));
  }

  FutureOr<void> _onSaveTask(event, emit) async {
    emit(TaskStorageSaving(repository.categories));
    await repository.saveTask(event.task);
    emit(TaskStorageRepositoryFinishedSaving(repository.categories));
  }

  Future<void> _onSaveCategory(event, emit) async {
    emit(TaskStorageSaving(repository.categories));
    await repository.saveCategory(event.category);
    emit(TaskStorageRepositoryFinishedSaving(repository.categories));
  }

  Future<void> _onWipe(event, emit) async {
    await repository.wipeStorage();
    emit(TaskStorageUninitialized());
  }

  Future<void> _onSave(event, emit) async {
    emit(TaskStorageSaving(repository.categories));
    await repository.save();
    emit(TaskStorageRepositoryFinishedSaving(repository.categories));
  }

  Future<void> _onLoad(event, emit) async {
    emit(TaskStorageLoading());
    await repository.reload();
    emit(TaskStorageLoaded(repository.categories));
  }

  void dispose() {
    _listen?.cancel();
    _loggingSubscription?.cancel();
  }
}
