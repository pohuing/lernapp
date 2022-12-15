import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/logic/nullable_extensions.dart';
import 'package:lernapp/widgets/general_purpose/adaptive_yes_no_option.dart';

import 'task_listing.dart';

class PlatformAdativeScaffold extends StatelessWidget {
  final List<Widget>? actions;
  final String title;
  final String? previousTitle;
  final Widget body;
  final bool primary;
  final bool useSliverAppBar;
  final bool allowBackGesture;
  final bool showAppBar;

  const PlatformAdativeScaffold({
    super.key,
    this.actions,
    required this.title,
    this.previousTitle,
    required this.body,
    bool? primary,
    bool? useSliverAppBar,
    bool? allowBackGesture,
    bool? showAppBar,
  })  : primary = primary ?? true,
        useSliverAppBar = useSliverAppBar ?? true,
        allowBackGesture = allowBackGesture ?? true,
        showAppBar = showAppBar ?? true;

  @override
  Widget build(BuildContext context) {
    Widget value;
    if (Platform.isIOS) {
      if (useSliverAppBar && showAppBar) {
        value = CupertinoPageScaffold(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(title),
                  previousPageTitle: previousTitle,
                  trailing: actions.map(
                    (value) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: value,
                    ),
                  ),
                )
              ];
            },
            body: body,
          ),
        );
      } else {
        value = CupertinoPageScaffold(
          navigationBar: showAppBar
              ? CupertinoNavigationBar(
                  previousPageTitle: previousTitle,
                  middle: Text(title),
                  trailing: actions.map(
                    (e) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: e,
                    ),
                  ),
                )
              : null,
          child: body,
        );
      }
      value = Material(
        color: Colors.transparent,
        child: value,
      );
    } else {
      if (useSliverAppBar && showAppBar) {
        value = Scaffold(
          primary: primary,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar.large(
                  title: Text(title),
                  actions: actions,
                ),
              ];
            },
            body: body,
          ),
        );
      } else {
        value = Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: actions,
          ),
          primary: primary,
          body: body,
        );
      }
    }

    if (!showAppBar) {
      value = SafeArea(child: value);
    }

    return WillPopScope(
      onWillPop: allowBackGesture
          ? null
          : () => Future.value(Navigator.of(context).userGestureInProgress),
      child: value,
    );
  }
}

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectionCubit, SelectionState>(
        builder: (context, state) => PlatformAdativeScaffold(
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
                  onChanged: (newValue) => null,
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
