import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:lernapp/model/task_category.dart';
import 'package:uuid/uuid.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit() : super(SelectionState(<UuidValue>{}, false, false));

  void deselectCategory(TaskCategory category) {
    final selected = Set<UuidValue>.from(state.selectedUuids);
    selected.removeAll(category.gatherUuids());

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
      emit(SelectionState({}, false, state.isSelecting));
    } else {
      enableSelectionMode();
    }
  }

  setShouldRandomize(bool value) {
    emit(state.copyWith(isRandomized: value));
  }
}

class SelectionState {
  final bool isSelecting;
  final Set<UuidValue> selectedUuids;
  final bool isRandomized;
  late final UnmodifiableListView<UuidValue> shuffled =
      UnmodifiableListView(selectedUuids.toList(growable: false)..shuffle());
  late final UnmodifiableListView<UuidValue> asList =
      UnmodifiableListView(selectedUuids);

  // Getter which returns optionally shuffled list of Uuids
  UnmodifiableListView<UuidValue> get maybeShuffledUuids =>
      isRandomized ? shuffled : asList;

  SelectionState(this.selectedUuids, this.isSelecting, this.isRandomized);

  bool entireCategoryIsSelected(TaskCategory category) {
    return selectedUuids.containsAll(category.gatherUuids());
  }

  SelectionState copyWith({
    bool? isSelecting,
    Set<UuidValue>? selectedUuids,
    bool? isRandomized,
  }) {
    return SelectionState(selectedUuids ?? this.selectedUuids,
        isSelecting ?? this.isSelecting, isRandomized ?? this.isRandomized,);
  }
}
