import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/repositories/task_repository.dart';
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
          future: context.read<TaskRepositoryBase>().findByUuid(uuid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TaskArea(
                task: snapshot.data!,
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              context.replace('/');
              // TODO communicate redirect reason with user
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
}
