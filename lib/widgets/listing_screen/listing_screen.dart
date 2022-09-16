import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/widgets/listing_screen/category_tile.dart';

import '../../main.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        primary: true,
        appBar: AppBar(
          title: const Text('Tasks'),
          actions: [
            IconButton(
              onPressed: () => context.push('/scratchpad'),
              icon: const Icon(Icons.draw_outlined),
            ),
            IconButton(
              onPressed: () => showAboutDialog(
                context: context,
                applicationIcon: const Image(
                  isAntiAlias: false,
                  width: 200,
                  image: AssetImage('images/dorime.gif'),
                ),
              ),
              icon: const Icon(Icons.info_outline),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: taskRepository.categories.length,
          primary: true,
          itemBuilder: (context, index) => CategoryTile(
            category: taskRepository.categories[index],
          ),
        ),
      );
}
