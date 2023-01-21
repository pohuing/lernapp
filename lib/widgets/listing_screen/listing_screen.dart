import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/logic/nullable_extensions.dart';
import 'package:lernapp/widgets/general_purpose/adaptive_alert_dialog.dart';
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
                if ((state as dynamic).contents.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/import');
                        },
                        child: Text(
                          'You don\'t appear to have any tasks yet. Tap here to import.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  );
                }
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
        ElevatedButton(
          onPressed: state.selectedUuids.isEmpty
              ? null
              : () => showDialog(
                    context: context,
                    builder: (context) => _sessionStartBuilder(),
                  ),
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

  Widget _sessionStartBuilder() {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, state) => AdaptiveAlertDialog(
        title: 'Configure Session',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile.adaptive(
              title: const Text('Number of questions'),
              value: state.withLimit,
              onChanged: (value) {
                if (value) {
                  context.read<SelectionCubit>().setLimit(1);
                } else {
                  context.read<SelectionCubit>().setLimit(-1);
                }
              },
            ),
            if (state.withLimit)
              ListTile(
                title: const Text('Count'),
                trailing: SizedBox(
                  width: 80,
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => int.tryParse(value)
                        .map(context.read<SelectionCubit>().setLimit),
                  ),
                ),
              ),
            SwitchListTile.adaptive(
              title: Text(
                'Randomize',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              value: state.isRandomized,
              onChanged: (_) => context
                  .read<SelectionCubit>()
                  .setShouldRandomize(!state.isRandomized),
            )
          ],
        ),
        actions: [
          IconButton(onPressed: context.pop, icon: const Icon(Icons.cancel)),
          TextButton(
            onPressed: () => context.push('/session'),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}
