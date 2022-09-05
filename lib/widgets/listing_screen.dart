import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: SafeArea(
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverAppBar(
              primary: true,
              title: const Text('Tasks'),
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: taskRepository.tasks.length,
                (context, index) {
                  return Hero(
                    tag: taskRepository.tasks[index].uuid,
                    child: Material(
                      child: ListTile(
                        title: Text(taskRepository.tasks[index].title),
                        onTap: () => context.pushNamed(
                          'Task',
                          params: {
                            'tid': taskRepository.tasks[index].uuid.toString()
                          },
                        ),
                        trailing: defaultTargetPlatform == TargetPlatform.iOS
                            ? Icon(Icons.adaptive.arrow_forward)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
