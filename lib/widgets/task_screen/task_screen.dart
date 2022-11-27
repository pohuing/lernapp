import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/repositories/task_repository.dart';
import 'package:lernapp/widgets/general_purpose/timed_snackbar.dart';
import 'package:lernapp/widgets/task_screen/task_area.dart';
import 'package:uuid/uuid.dart';

class TaskScreen extends StatelessWidget {
  final UuidValue uuid;

  const TaskScreen({Key? key, required this.uuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: () async {
            final result =
                await context.read<TaskRepositoryBase>().findByUuid(uuid);
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
              return const Center(
                child: Text(
                  'Something went wrong, could not find any data for that task id',
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void redirect(BuildContext context) {
    context.replace('/');
    showTimedSnackBar(context, 'Found no task with that Uuid');
  }
}
