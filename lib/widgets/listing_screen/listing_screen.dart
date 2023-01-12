import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/widgets/general_purpose/adaptive_yes_no_option.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/import_flow/import_tile.dart';

import 'task_listing.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectionCubit, SelectionState>(
        builder: (context, state) => PlatformAdaptiveScaffold(
          title: 'Tasks',
          actions: _buildAppBar(state, context),
          body: BlocBuilder<TasksBloc, TaskStorageStateBase>(
            buildWhen: (previous, current) =>
                current is TaskStorageLoaded ||
                current is TaskStorageLoading ||
                current is TaskStorageUninitialized ||
                current is TaskStorageChanged,
            builder: (context, state) {
              if (state is TaskStorageUninitialized) {
                context.read<TasksBloc>().add(TaskStorageLoad());
                return const Center(
                  child: Text('Storage is uninitialized'),
                );
              } else if (state is TaskStorageLoaded ||
                  state is TaskStorageRepositoryFinishedSaving) {
                return TaskListing(
                  key: Key(state.hashCode.toString()),
                  categories: (state as dynamic).contents,
                  withNavBarStyle: true,
                );
              } else if (state is TaskStorageLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                return Text(state.toString());
              }
            },
          ),
        ),
      );

  List<Widget> _buildAppBar(SelectionState state, BuildContext context) {
    return [
      if (!state.isSelecting)
        IconButton(
          onPressed: () => context.read<SelectionCubit>().toggleSelectionMode(),
          icon: const Icon(Icons.check_box_outlined),
        ),
      if (state.isSelecting)
        TextButton(
          onPressed: () => context.read<SelectionCubit>().toggleSelectionMode(),
          child: const Text('Cancel'),
        ),
      if (state.isSelecting)
        InkWell(
          onTap: () => context
              .read<SelectionCubit>()
              .setShouldRandomize(!state.isRandomized),
          child: Row(
            children: [
              Text(
                'Randomize',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              IgnorePointer(
                child: AdaptiveYesNoOption(
                  value: state.isRandomized,
                  onChanged: (newValue) {},
                ),
              ),
            ],
          ),
        ),
      if (state.isSelecting)
        ElevatedButton(
          onPressed: state.selectedUuids.isEmpty
              ? null
              : () => context.pushNamed('session'),
          child: const Text('Start'),
        ),
      if (!state.isSelecting)
        PopupMenuButton(
          position: PopupMenuPosition.under,
          itemBuilder: (context) => [
            PopupMenuItem(
              padding: EdgeInsets.zero,
              onTap: () => context.read<TasksBloc>().add(TaskStorageSave()),
              child: const IgnorePointer(
                child: ListTile(
                  leading: Icon(Icons.save),
                  title: Text('Save'),
                ),
              ),
            ),
            const PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ImportTile(),
            ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              onTap: () async =>
                  context.read<TasksBloc>().add(TaskStorageWipe()),
              child: const IgnorePointer(
                child: ListTile(
                  leading: Icon(Icons.delete_forever),
                  title: Text('Reset storage'),
                ),
              ),
            ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              onTap: () => context.push('/scratchpad'),
              child: const IgnorePointer(
                child: ListTile(
                  leading: Icon(Icons.draw),
                  title: Text('Scribble'),
                ),
              ),
            ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              onTap: () => context.push('/preferences'),
              child: const IgnorePointer(
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
            ),
            const PopupMenuItem(
              padding: EdgeInsets.zero,
              child: AboutListTile(
                icon: Icon(Icons.info),
                applicationIcon: Image(
                  isAntiAlias: false,
                  width: 200,
                  image: AssetImage('images/dorime.gif'),
                ),
              ),
            ),
          ],
        )
    ];
  }
}
