import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListingScreen extends StatelessWidget {
  ListingScreen({Key? key}) : super(key: key);

  final tasks = [1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: CustomScrollView(
        primary: true,
        slivers: [
          const SliverAppBar(
            primary: true,
            title: Text('Tasks'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: tasks.length,
              (context, index) {
                return ListTile(
                  title: Text(index.toString()),
                  onTap: () => context.pushNamed(
                    'Task',
                    params: {'tid': index.toString()},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
