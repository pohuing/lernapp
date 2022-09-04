import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ameno_ipsum/flutter_ameno_ipsum.dart';
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
                childCount: 40,
                (context, index) {
                  final title = ameno(paragraphs: 1, words: 4);
                  return Hero(
                    tag: title,
                    child: Material(
                      child: ListTile(
                        title: Text(title),
                        onTap: () => context.pushNamed(
                          'Task',
                          params: {'tid': title},
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
