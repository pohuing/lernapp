import 'package:flutter/material.dart';
import 'package:lernapp/widgets/task_screen/task_area.dart';
import 'package:uuid/uuid.dart';

class TaskScreen extends StatelessWidget {
  final UuidValue uuid;

  const TaskScreen({Key? key, required this.uuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TaskArea(uuid: uuid),
    );
  }
}
