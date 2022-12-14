import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/session_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/widgets/listing_screen/listing_screen.dart';
import 'package:lernapp/widgets/task_screen/task_area.dart';
import 'package:uuid/uuid.dart';

class SessionScreen extends StatefulWidget {
  final List<UuidValue> tasks;

  const SessionScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late final SessionCubit cubit;

  @override
  Widget build(BuildContext context) {
    return PlatformAdativeScaffold(
      title: 'Session',
      scrollable: false,
      primary: true,
      previousTitle: 'Tasks',
      actions: [
        TextButton(
          onPressed: () => cubit.previous(),
          child: const Text('Previous'),
        ),
        ElevatedButton(
          onPressed: () => cubit.next(),
          child: const Text('Next'),
        ),
      ],
      body: BlocBuilder<SessionCubit, SessionState>(
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
    );
  }

  @override
  void initState() {
    cubit = SessionCubit(widget.tasks);
    cubit.next();
    super.initState();
  }
}
