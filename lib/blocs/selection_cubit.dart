import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:lernapp/logic/list_extensions.dart';
import 'package:lernapp/model/task_category.dart';
import 'package:uuid/uuid.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit() : super(SelectionState(<UuidValue>{}, false, false, -1));

  void deselectCategory(TaskCategory category) {
    final selected = Set<UuidValue>.from(state.selectedUuids);
    selected.removeAll(category.gatherUuids());

    emit(state.copyWith(selectedUuids: selected));
  }

  /// Remove tasks with matching uuid
  void deselectTasks(Set<UuidValue> taskUuids) {
    final selected = Set<UuidValue>.from(state.selectedUuids);
    selected.removeAll(taskUuids);
    emit(state.copyWith(selectedUuids: selected));
  }

  /// Remove all tasks which are not in [taskUuids]
  void retainTasks(Set<UuidValue> taskUuids) {
    final selected = Set<UuidValue>.from(state.selectedUuids);
    selected.retainAll(taskUuids);
    emit(state.copyWith(selectedUuids: selected));
  }

  void enableSelectionMode() {
    emit(state.copyWith(isSelecting: true));
  }

  void selectCategory(TaskCategory category) {
    final selected = Set<UuidValue>.from(state.selectedUuids);
    selected.addAll(category.gatherUuids());

    emit(state.copyWith(selectedUuids: selected));
  }

  void toggleCategory(TaskCategory category) {
    if (state.entireCategoryIsSelected(category)) {
      deselectCategory(category);
    } else {
      selectCategory(category);
    }
  }

  void toggleSelection(UuidValue uuid) {
    final selected = Set<UuidValue>.from(state.selectedUuids);
    if (selected.contains(uuid)) {
      selected.remove(uuid);
    } else {
      selected.add(uuid);
    }

    emit(state.copyWith(selectedUuids: selected));
  }

  void toggleSelectionMode() {
    if (state.isSelecting) {
      emit(SelectionState({}, false, state.isSelecting, -1));
    } else {
      enableSelectionMode();
    }
  }

  void setShouldRandomize(bool value) {
    emit(state.copyWith(isRandomized: value));
  }

  void setLimit(int limit) {
    emit(state.copyWith(limit: limit));
  }
}

class SelectionState {
  final bool isSelecting;
  final Set<UuidValue> selectedUuids;
  final bool isRandomized;

  /// A non positive value means no limit
  final int limit;

  bool get withLimit => limit > 0;

  late final UnmodifiableListView<UuidValue> shuffled = UnmodifiableListView(
    selectedUuids
        .toList(growable: false)
        .shuffled()
        .maybeTransform(withLimit, (e) => e.take(limit)),
  );
  late final UnmodifiableListView<UuidValue> asList = UnmodifiableListView(
    selectedUuids.maybeTransform(withLimit, (e) => e.take(limit)),
  );

  /// Getter which returns optionally shuffled list of Uuids
  UnmodifiableListView<UuidValue> get maybeShuffledUuids =>
      isRandomized ? shuffled : asList;

  SelectionState(
    this.selectedUuids,
    this.isSelecting,
    this.isRandomized,
    this.limit,
  );

  /// Returns true if [selectedUuids] contains all Uuids of [category]
  bool entireCategoryIsSelected(TaskCategory category) {
    return selectedUuids.containsAll(category.gatherUuids());
  }

  /// Returns [true] if [selectedUuids] contains all Uuids of [category]
  /// Returns [false] if [selectedUuids] contains no Uuids of [category]
  /// returns [null] if [selectedUuids] contains some but not all Uuids of [category]
  bool? isCategorySelectedTristate(TaskCategory category) {
    final uuids = category.gatherUuids();
    if (selectedUuids.containsAll(uuids)) {
      return true;
    } else if (uuids.any(selectedUuids.contains)) {
      return null;
    } else {
      return false;
    }
  }

  SelectionState copyWith({
    bool? isSelecting,
    Set<UuidValue>? selectedUuids,
    bool? isRandomized,
    int? limit,
  }) {
    return SelectionState(
      selectedUuids ?? this.selectedUuids,
      isSelecting ?? this.isSelecting,
      isRandomized ?? this.isRandomized,
      limit ?? this.limit,
    );
  }
}
