import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/model/custom_date_time_range.dart';
import 'package:lernapp/model/task_category.dart';
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
  final cubit = SelectionCubit()..toggleSelectionMode();

  Future<List<TaskCategory>>? loader;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: PlatformAdaptiveScaffold(
        title: 'History',
        primary: true,
        trailing: buildTrailing(),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.av_timer),
              title: const Text('Time Frame'),
              trailing: IconButton(
                onPressed: onResetPressed,
                icon: const Icon(Icons.undo),
              ),
            ),
            DateTimeTile(
              title: 'Start:',
              value: range.start,
              onChange: onStartChange,
            ),
            DateTimeTile(
              title: 'End:',
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
                      if (snapshot.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              'No questions have been answered in this time frame',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        );
                      }
                      return TaskListing(
                        shrinkWrap: true,
                        categories: snapshot.data!,
                        withNavBarStyle: true,
                        showMostRecent: true,
                      );
                  }
                },
              ),
            )
          ],
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
    loader = context.read<TasksBloc>().repository.recent(range);
  }

  @override
  void initState() {
    updateLoader();
    super.initState();
  }

  Widget buildTrailing() {
    return BlocBuilder<SelectionCubit, SelectionState>(
      bloc: cubit,
      builder: (context, state) => FilledButton(
        onPressed: state.maybeShuffledUuids.isEmpty
            ? null
            : () => context.push('/review', extra: state.maybeShuffledUuids),
        child: const Text('Start'),
      ),
    );
  }
}
