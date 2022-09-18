import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/session_cubit.dart';
import 'package:lernapp/widgets/task_screen/task_area.dart';

import '../../model/task.dart';

class SessionScreen extends StatefulWidget {
  final List<Task> initTasks;
  const SessionScreen({Key? key, required List<Task> tasks})
      : initTasks = tasks,
        super(key: key);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late final SessionCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.canPop() ? context.pop() : context.goNamed('listing');
          },
        ),
        actions: [
          TextButton(
            onPressed: () => cubit.previous(),
            child: const Text('Previous'),
          ),
          ElevatedButton(
            onPressed: () => cubit.next(),
            child: const Text('next'),
          ),
        ],
      ),
      body: BlocBuilder<SessionCubit, SessionState>(
        bloc: cubit,
        builder: (context, state) {
          return TaskArea(
            key: Key(state.currentTask!.uuid.toString()),
            showBackButton: false,
            uuid: state.currentTask!.uuid,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    cubit = SessionCubit(widget.initTasks);
    cubit.next();
    super.initState();
  }
}
