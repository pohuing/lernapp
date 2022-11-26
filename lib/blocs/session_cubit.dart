import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';


class SessionCubit extends Cubit<SessionState> {
  SessionCubit(List<UuidValue> tasks) : super(SessionState(tasks, null, -1));

  void next() {
    var index = (state.index + 1) % state.tasks.length;
    emit(SessionState(state.tasks, state.tasks[index], index));
  }

  void previous() {
    final index = (state.index - 1) % state.tasks.length;
    emit(SessionState(state.tasks, state.tasks[index], index));
  }

  void shuffle() {
    emit(
      SessionState(
        List.from(state.tasks)..shuffle(),
        state.currentTask,
        state.index,
      ),
    );
  }
}

class SessionState {
  final List<UuidValue> tasks;
  final UuidValue? currentTask;
  final int index;

  SessionState(this.tasks, this.currentTask, this.index);

  @override
  int get hashCode => tasks.hashCode ^ currentTask.hashCode ^ index.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionState &&
          runtimeType == other.runtimeType &&
          tasks == other.tasks &&
          currentTask == other.currentTask &&
          index == other.index;

  @override
  String toString() {
    return 'SessionState{currentTask: $currentTask, index: $index}';
  }
}
