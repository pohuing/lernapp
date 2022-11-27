import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lernapp/repositories/task_repository.dart';

import 'events.dart';
import 'states.dart';

class TasksBloc extends Bloc<TaskStorageEventBase, TaskStorageStateBase> {
  TaskRepositoryBase repository;

  TasksBloc(this.repository) : super(TaskStorageUninitialized()) {
    on<TaskStorageLoad>(_onLoad);

    on<TaskStorageSave>(_onSave);

    on<TaskStorageWipe>(_onWipe);

    on<TaskStorageSaveCategory>(_onSaveCategory);

    on<TaskStorageSaveTask>(_onSaveTask);
  }

  FutureOr<void> _onSaveTask(event, emit) async {
    emit(TaskStorageSaving());
    await repository.saveTask(event.task);
    emit(TaskStorageRepositoryFinishedSaving(repository.categories));
  }

  Future<void> _onSaveCategory(event, emit) async {
    emit(TaskStorageSaving());
    await repository.saveCategory(event.category);
    emit(TaskStorageRepositoryFinishedSaving(repository.categories));
  }

  Future<void> _onWipe(event, emit) async {
    await repository.wipeStorage();
    emit(TaskStorageUninitialized());
  }

  Future<void> _onSave(event, emit) async {
    emit(TaskStorageSaving());
    await repository.save();
    emit(TaskStorageRepositoryFinishedSaving(repository.categories));
  }

  Future<void> _onLoad(event, emit) async {
    emit(TaskStorageLoading());
    await repository.reload();
    emit(TaskStorageLoaded(repository.categories));
  }
}
