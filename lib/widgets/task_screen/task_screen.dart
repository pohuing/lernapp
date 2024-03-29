import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/widgets/general_purpose/timed_snackbar.dart';
import 'package:lernapp/widgets/task_screen/task_area.dart';
import 'package:uuid/uuid.dart';

class TaskScreen extends StatelessWidget {
  final UuidValue uuid;

  const TaskScreen({super.key, required this.uuid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Task?>(
          future: () async {
            final result =
                await context.read<TasksBloc>().repository.findByUuid(uuid);
            if (result == null) {
              // Stateless widgets cannot be unmounted thus we don't need to check if the context is active
              // ignore: use_build_context_synchronously
              redirect(context);
            }
            return result;
          }(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TaskArea(
                task: snapshot.data!,
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(S.of(context).taskScreen_errorTitle),
                ),
                body: Center(
                  child: Text(S.of(context).sessionScreen_unknownTaskIdHint),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(S.of(context).taskScreen_loadingTitle),
                ),
                body: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void redirect(BuildContext context) {
    context.go('/');
    showTimedSnackBar(context, 'Found no task with that Uuid');
  }
}
