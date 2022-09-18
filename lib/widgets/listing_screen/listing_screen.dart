import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/widgets/listing_screen/category_tile.dart';

import '../../main.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectionCubit, SelectionState>(
        builder: (context, state) => Scaffold(
          primary: true,
          appBar: AppBar(
            title: const Text('Tasks'),
            actions: [
              if (!state.isSelecting)
                IconButton(
                  onPressed: () => context.push('/scratchpad'),
                  icon: const Icon(Icons.draw_outlined),
                ),
              if (!state.isSelecting)
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
                ),
              if (!state.isSelecting)
                IconButton(
                  onPressed: () =>
                      context.read<SelectionCubit>().toggleSelectionMode(),
                  icon: const Icon(Icons.check_box_outlined),
                ),
              if (state.isSelecting)
                Container(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: () =>
                        context.read<SelectionCubit>().toggleSelectionMode(),
                    child: const Text('Cancel selection'),
                  ),
                ),
              if (state.isSelecting)
                Container(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () =>
                        log('Start session with Uuids ${state.selectedUuids}'),
                    child: const Text('Start Session'),
                  ),
                ),
            ],
          ),
          body: ListView.builder(
            itemCount: taskRepository.categories.length,
            primary: true,
            itemBuilder: (context, index) => CategoryTile(
              category: taskRepository.categories[index],
            ),
          ),
        ),
      );
}
