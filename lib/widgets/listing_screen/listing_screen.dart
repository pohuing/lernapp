import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/listing_screen/connected_task_listing.dart';
import 'package:lernapp/widgets/listing_screen/start_session_dialog.dart';

import '../import_flow/import_tile.dart';
import 'about_list_tile.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectionCubit(),
      child: Builder(
        builder: (context) {
          return PlatformAdaptiveScaffold(
            title: 'Listing',
            body: ConnectedTaskListing(),
            trailing: Trailing(),
          );
        },
      ),
    );
  }
}

class Trailing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, state) {
        return Row(
          children: [
            if (!state.isSelecting) ...[
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
