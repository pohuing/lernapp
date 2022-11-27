import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/tasks/events.dart';
import 'package:lernapp/blocs/tasks/states.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/widgets/high_perf_listing_screen/high_perf_listing.dart';

class HighPerfListingScreen extends StatelessWidget {
  final bool withNavBarStyle;

  const HighPerfListingScreen({Key? key, bool? withNavBarStyle})
      : withNavBarStyle = withNavBarStyle ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TaskStorageStateBase>(
      buildWhen: (previous, current) =>
          current is TaskStorageLoaded ||
          current is TaskStorageLoading ||
          current is TaskStorageUninitialized,
      builder: (context, state) {
        if (state is TaskStorageUninitialized) {
          context.read<TasksBloc>().add(TaskStorageLoad());
          return const Center(child: Text('Storage is uninitialized'));
        } else if (state is TaskStorageLoaded ||
            state is TaskStorageRepositoryFinishedSaving) {
          return HighPerfListing(
            categories: (state as dynamic).contents,
            withNavBarStyle: withNavBarStyle,
          );
        } else if (state is TaskStorageLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Text(state.toString());
        }
      },
    );
  }
}
