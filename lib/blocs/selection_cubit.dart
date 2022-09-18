import 'package:bloc/bloc.dart';
import 'package:lernapp/model/task_category.dart';
import 'package:uuid/uuid.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit() : super(SelectionState(<UuidValue>{}, false));

  void deselectCategory(TaskCategory category) {
    final selected = Set<UuidValue>.from(state.selectedUuids);
    selected.removeAll(category.gatherUuids());

    emit(SelectionState(selected, state.isSelecting));
  }

  void enableSelectionMode() {
    emit(SelectionState(state.selectedUuids, true));
  }

  void selectCategory(TaskCategory category) {
    final selected = Set<UuidValue>.from(state.selectedUuids);
    selected.addAll(category.gatherUuids());

    emit(SelectionState(selected, state.isSelecting));
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

    emit(SelectionState(selected, state.isSelecting));
  }

  void toggleSelectionMode() {
    if (state.isSelecting) {
      emit(SelectionState({}, false));
    } else {
      enableSelectionMode();
    }
  }
}

class SelectionState {
  final bool isSelecting;
  final Set<UuidValue> selectedUuids;

  SelectionState(this.selectedUuids, this.isSelecting);

  bool entireCategoryIsSelected(TaskCategory category) {
    return selectedUuids.containsAll(category.gatherUuids());
  }
}
