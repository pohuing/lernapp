import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            const SliverAppBar(
              primary: true,
              title: Text('Tasks'),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 40,
                (context, index) {
                  return Hero(
                    tag: index.toString(),
                    child: Material(
                      child: ListTile(
                        title: Text(index.toString()),
                        onTap: () => context.pushNamed(
                          'Task',
                          params: {'tid': index.toString()},
                        ),
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
