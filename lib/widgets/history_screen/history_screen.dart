import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/model/custom_date_time_range.dart';
import 'package:lernapp/model/task_category.dart';
import 'package:lernapp/widgets/general_purpose/optionally_wrapped.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/history_screen/date_time_tile.dart';
import 'package:lernapp/widgets/listing_screen/task_listing.dart';

/// A Screen which lets the user select a timespan and then shows tasks which
/// have been answered in the timespan
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  CustomDateTimeRange range = CustomDateTimeRange(
    DateTime.now().subtract(const Duration(hours: 1)),
    DateTime.now(),
  );
  final SelectionCubit selectionCubit = SelectionCubit();

  Future<List<TaskCategory>>? loader;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksBloc, TaskStorageStateBase>(
      listener: (context, state) => setState(() => updateLoader()),
      child: BlocProvider.value(
        value: selectionCubit,
        child: PlatformAdaptiveScaffold(
          title: S.of(context).historyScreen_title,
          primary: true,
          trailing: buildTrailing(),
          body: OptionallyWrapped(
            applyWrapper: !kIsWeb && Platform.isIOS,
            wrapper: (context, child) => SafeArea(child: child),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.av_timer),
                  title: Text(S.of(context).historyScreen_timeFrameTitle),
                  trailing: IconButton(
                    onPressed: onResetPressed,
                    icon: const Icon(Icons.undo),
                  ),
                ),
                DateTimeTile(
                  title: S.of(context).historyScreen_startTitle,
                  value: range.start,
                  onChange: onStartChange,
                ),
                DateTimeTile(
                  title: S.of(context).historyScreen_endTitle,
                  value: range.end,
                  onChange: onEndChange,
                ),
                const Divider(),
                SizedBox(
                  child: FutureBuilder<List<TaskCategory>>(
                    future: loader,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return const CircularProgressIndicator.adaptive();
                        case ConnectionState.done:
                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  S
                                      .of(context)
                                      .historyScreen_noAnswersInTimeFrameHint,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            );
                          } else {
                            return TaskListing(
                              shrinkWrap: true,
                              categories: snapshot.data!,
                              showMostRecent: true,
                            );
                          }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onResetPressed() {
    setState(() {
      range = CustomDateTimeRange(
        DateTime.now().subtract(const Duration(hours: 1)),
        DateTime.now(),
      );
      updateLoader();
    });
  }

  void onStartChange(DateTime start) {
    // Don't change range if there's only a seconds difference to prevent
    // unnecessary queries
    if (range.start
            .difference(start)
            .abs()
            .compareTo(const Duration(minutes: 1)) >
        0) {
      setState(() {
        range = range.copyWith(start: start).sorted();
        updateLoader();
      });
    }
  }

  void onEndChange(DateTime end) {
    // Don't change range if there's only a seconds difference to prevent
    // unnecessary queries
    if (range.start
            .difference(end)
            .abs()
            .compareTo(const Duration(minutes: 1)) >
        0) {
      setState(() {
        range = range.copyWith(end: end).sorted();
        updateLoader();
      });
    }
  }

  void updateLoader() {
    loader = () async {
      var recent = await context.read<TasksBloc>().repository.recent(range);

      /// Deselect tasks which are no longer visible
      selectionCubit.retainTasks(
        recent.fold(
          {},
          (previousValue, category) =>
              previousValue..addAll(category.gatherUuids()),
        ),
      );
      return recent;
    }();
  }

  @override
  void initState() {
    selectionCubit.toggleSelectionMode();
    updateLoader();
    super.initState();
  }

  Widget buildTrailing() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: BlocBuilder<SelectionCubit, SelectionState>(
        builder: (context, state) => FilledButton(
          onPressed: state.maybeShuffledUuids.isEmpty
              ? null
              : () => context.push('/review', extra: state.maybeShuffledUuids),
          child: Text(S.of(context).historyScreen_startButtonTitle),
        ),
      ),
    );
  }
}
