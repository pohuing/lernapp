import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/logic/list_extensions.dart';

import '../main.dart';

class ListingScreenNonSliver extends StatelessWidget {
  const ListingScreenNonSliver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            onPressed: () => showAboutDialog(
              context: context,
              applicationIcon: const SizedBox(
                width: 100,
                height: 100,
                child: Placeholder(),
              ),
            ),
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: taskRepository.tasks.length,
        primary: true,
        itemBuilder: (context, index) {
          return Hero(
            tag: taskRepository.tasks[index].uuid,
            child: Material(
              color: Colors.primaries.random(),
              child: ListTile(
                title: Text(taskRepository.tasks[index].title),
                onTap: () => context.pushNamed(
                  'Task',
                  params: {'tid': taskRepository.tasks[index].uuid.toString()},
                ),
                trailing: defaultTargetPlatform == TargetPlatform.iOS
                    ? Icon(Icons.adaptive.arrow_forward)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
