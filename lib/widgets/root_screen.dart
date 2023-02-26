import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold/tab_destination.dart';
import 'package:lernapp/widgets/history_screen/history_screen.dart';
import 'package:lernapp/widgets/import_flow/import_tile.dart';
import 'package:lernapp/widgets/listing_screen/about_list_tile.dart';
import 'package:lernapp/widgets/listing_screen/connected_task_listing.dart';
import 'package:lernapp/widgets/listing_screen/start_session_dialog.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, state) => PlatformAdaptiveScaffold(
        destinations: [
          TabDestination(
            () => const ConnectedTaskListing(),
            'Tasks',
            const Icon(Icons.list),
          ),
          TabDestination(() => HistoryScreen(), 'History', Icon(Icons.history)),
        ],
        actions: buildActions(state),
        scrollController: scrollController,
      ),
    );
  }

  List<Widget>? buildActions(SelectionState state) {
    return [
      if (!state.isSelecting)
        IconButton(
          onPressed: () => context.read<SelectionCubit>().toggleSelectionMode(),
          icon: const Icon(Icons.check_box_outlined),
        ),
      if (state.isSelecting)
        OutlinedButton(
          onPressed: () => context.read<SelectionCubit>().toggleSelectionMode(),
          child: const Text('Cancel'),
        ),
      if (state.isSelecting)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: FilledButton(
            onPressed: state.selectedUuids.isEmpty
                ? null
                : () => showDialog(
                      context: context,
                      builder: (context) => const StartSessionDialog(),
                    ),
            child: const Text('Start'),
          ),
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
              child: CustomAboutListTile(),
            ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              onTap: () => context.push('/history'),
              child: const IgnorePointer(
                child: ListTile(
                  title: Text('History'),
                  leading: Icon(Icons.history),
                ),
              ),
            )
          ],
        )
    ];
  }
}
