import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/widgets/general_purpose/optionally_wrapped.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/import_flow/import_tile.dart';
import 'package:lernapp/widgets/listing_screen/connected_task_listing.dart';
import 'package:lernapp/widgets/listing_screen/start_session_dialog.dart';

import '../../generated/l10n.dart';
import 'about_list_tile.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectionCubit(),
      child: Builder(
        builder: (context) {
          return PlatformAdaptiveScaffold(
            title: S.of(context).listingScreen_title,
            body: OptionallyWrapped(
              applyWrapper: !kIsWeb && Platform.isIOS,
              wrapper: (context, child) => SafeArea(child: child),
              child: const ConnectedTaskListing(),
            ),
            primary: true,
            trailing: const Trailing(),
          );
        },
      ),
    );
  }
}

class Trailing extends StatelessWidget {
  const Trailing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!state.isSelecting) ...[
              IconButton(
                tooltip: S
                    .of(context)
                    .listingScreenTrailing_sessionModeButtonTooltip,
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
                    child: IgnorePointer(
                      child: ListTile(
                        leading: const Icon(Icons.draw),
                        title: Text(
                          S.of(context).listingScreenTrailing_scribbleTitle,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    onTap: () => context.push('/preferences'),
                    child: IgnorePointer(
                      child: ListTile(
                        leading: const Icon(Icons.settings),
                        title: Text(
                          S.of(context).listingScreenTrailing_settingsTitle,
                        ),
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: CustomAboutListTile(),
                  ),
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    onTap: () => context.push('/editor'),
                    child: const IgnorePointer(
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Editor'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (state.isSelecting) ...[
              OutlinedButton(
                onPressed: () =>
                    context.read<SelectionCubit>().toggleSelectionMode(),
                child: Text(S.of(context).cancel),
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
                  child: Text(S.of(context).start),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
