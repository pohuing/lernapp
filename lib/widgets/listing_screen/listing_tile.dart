import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: task.uuid,
      child: Material(
        child: ListTile(
          title: Text(
            task.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => context.pushNamed(
            'Task',
            params: {'tid': task.uuid.toString()},
          ),
          trailing: defaultTargetPlatform == TargetPlatform.iOS
              ? Icon(Icons.adaptive.arrow_forward)
              : null,
        ),
      ),
    );
  }
}
