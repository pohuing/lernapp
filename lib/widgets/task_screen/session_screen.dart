import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/session_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/task_screen/task_area.dart';
import 'package:uuid/uuid.dart';

class SessionScreen extends StatefulWidget {
  final List<UuidValue> tasks;
  final bool reviewStyle;

  const SessionScreen({super.key, required this.tasks, bool? reviewStyle})
      : reviewStyle = reviewStyle ?? false;

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late final SessionCubit cubit;

  @override
  Widget build(BuildContext context) {
    return PlatformAdaptiveScaffold(
      title: widget.reviewStyle ? 'Review' : 'Session',
      useSliverAppBar: false,
      previousTitle: 'Tasks',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => cubit.previous(),
            child: const Text('Previous'),
          ),
          BlocBuilder<SessionCubit, SessionState>(
            bloc: cubit,
            builder: (context, state) => Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  '${state.index + 1}/${state.tasks.length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => cubit.next(),
            child: const Text('Next'),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<SessionCubit, SessionState>(
          bloc: cubit,
          builder: (context, state) {
            return FutureBuilder(
              key: Key(state.currentTask.toString()),
              future: context
                  .read<TasksBloc>()
                  .repository
                  .findByUuid(state.currentTask!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return TaskArea(
                    key: Key(state.currentTask!.uuid.toString()),
                    showBackButton: false,
                    task: snapshot.data!,
                    reviewStyle: widget.reviewStyle,
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return const Center(
                    child: Text(
                      'Something went wrong, could not find any data for that task id',
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    cubit = SessionCubit(widget.tasks);
    cubit.next();
    super.initState();
  }
}
