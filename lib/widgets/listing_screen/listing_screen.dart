import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';

import 'task_listing.dart';

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
                    onPressed: state.selectedUuids.isEmpty
                        ? null
                        : () => context.goNamed('session'),
                    child: const Text('Start Session'),
                  ),
                ),
              if (!state.isSelecting)
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () =>
                          context.read<TasksBloc>().add(TaskStorageSave()),
                      child: const ListTile(
                        leading: Icon(Icons.save),
                        title: Text('Save'),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        context.read<TasksBloc>().add(TaskStorageWipe());
                      },
                      child: const ListTile(
                        leading: Icon(Icons.delete_forever),
                        title: Text('Reset storage'),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => context.push('/scratchpad'),
                      child: const ListTile(
                        leading: Icon(Icons.draw_outlined),
                        title: Text('Scribble'),
                      ),
                    ),
                    PopupMenuItem(
                      child: const ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('About'),
                      ),
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationIcon: const Image(
                          isAntiAlias: false,
                          width: 200,
                          image: AssetImage('images/dorime.gif'),
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
          body: BlocBuilder<TasksBloc, TaskStorageStateBase>(
            buildWhen: (previous, current) =>
                current is TaskStorageLoaded ||
                current is TaskStorageLoading ||
                current is TaskStorageUninitialized,
            builder: (context, state) {
              if (state is TaskStorageUninitialized) {
                context.read<TasksBloc>().add(TaskStorageLoad());
                return const Center(
                  child: Text('Storage is uninitialized'),
                );
              } else if (state is TaskStorageLoaded ||
                  state is TaskStorageRepositoryFinishedSaving) {
                return TaskListing(
                  categories: (state as dynamic).contents,
                  withNavBarStyle: true,
                );
              } else if (state is TaskStorageLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Text(state.toString());
              }
            },
          ),
        ),
      );
}
