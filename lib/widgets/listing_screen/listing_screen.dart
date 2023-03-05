import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/widgets/create_task_screen.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/listing_screen/connected_task_listing.dart';
import 'package:lernapp/widgets/listing_screen/start_session_dialog.dart';
import 'package:lernapp/widgets/task_screen/task_card.dart';

import '../import_flow/import_tile.dart';
import 'about_list_tile.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  bool showAddScreen = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectionCubit(),
      child: Builder(
        builder: (context) {
          return PlatformAdaptiveScaffold(
            title: 'Tasks',
            primary: true,
            useSliverAppBar: false,
            trailing: Trailing(onTapAdd: onTapAdd),
            body: AdaptiveLayout(
              body: SlotLayout(
                config: {
                  Breakpoints.standard: SlotLayout.from(
                    builder: (context) => const ConnectedTaskListing(
                      key: Key('body'),
                      allowReordering: true,
                    ),
                    key: const Key('body'),
                  ),
                },
              ),
              secondaryBody: SlotLayout(
                key: const Key('secondary'),
                config: {
                  if (showAddScreen)
                    Breakpoints.mediumAndUp: SlotLayout.from(
                      key: const Key('editor'),
                      outAnimation: (widget, animation) {
                        return widget;
                      },
                      builder: (context) => CreateTaskDialog(
                        secondaryAction: (task) => buildDraggable(task),
                      ),
                    )
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Draggable<Task> buildDraggable(Task task) {
    return Draggable(
      dragAnchorStrategy: pointerDragAnchorStrategy,
      data: task,
      maxSimultaneousDrags:
          task.title.isNotEmpty || task.description.isNotEmpty ? 1 : 0,
      feedback: Material(
        child: SizedBox(
          height: 100,
          width: 100,
          child: TaskCard(
            title: task.title,
            description: task.description,
            showBackButton: false,
          ),
        ),
      ),
      childWhenDragging: null,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.drag_indicator),
      ),
    );
  }

  void onTapAdd() {
    if (Breakpoints.small.isActive(context)) {
      showModal<Task?>(
        context: context,
        builder: (context) => Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: context.pop,
            label: Text('confirm'),
            icon: Icon(Icons.fullscreen_exit),
          ),
          body: const CreateTaskDialog(),
        ),
      );
    } else {
      setState(() {
        showAddScreen = !showAddScreen;
      });
    }
  }
}

class Trailing extends StatelessWidget {
  final void Function() onTapAdd;

  const Trailing({super.key, required this.onTapAdd});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!state.isSelecting) ...[
              IconButton(onPressed: onTapAdd, icon: const Icon(Icons.add)),
              IconButton(
                onPressed: () =>
                    context.read<SelectionCubit>().toggleSelectionMode(),
                icon: const Icon(Icons.check_box_outlined),
              ),
              PopupMenuButton(
                position: PopupMenuPosition.under,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: ImportTile(),
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
                ],
              ),
            ],
            if (state.isSelecting) ...[
              OutlinedButton(
                onPressed: () =>
                    context.read<SelectionCubit>().toggleSelectionMode(),
                child: const Text('Cancel'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FilledButton(
                  onPressed: state.selectedUuids.isEmpty
                      ? null
                      : () => showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(
                              value: context.read<SelectionCubit>(),
                              child: const StartSessionDialog(),
                            ),
                          ),
                  child: const Text('Start'),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
