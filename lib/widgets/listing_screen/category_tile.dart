import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/model/high_performance_listing_wrappers.dart';
import 'package:lernapp/model/task.dart';

import '../../blocs/selection_cubit.dart';

class CategoryTile extends StatelessWidget {
  final ListingEntryCategory entry;
  final Function()? onTap;
  final bool allowReordering;

  const CategoryTile({
    super.key,
    required this.entry,
    this.onTap,
    bool? allowReordering,
  }) : allowReordering = allowReordering ?? true;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAccept: (data) => allowReordering,
      onAcceptWithDetails: (details) => onAcceptWithDetails(details, context),
      builder: (context, candidateData, rejectedData) => Material(
        child: Padding(
          padding: EdgeInsets.only(left: entry.depth * 16),
          child: BlocBuilder<SelectionCubit, SelectionState>(
            builder: (context, state) => Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {
                      onTap?.call();
                    },
                    tileColor: entry.isExpanded
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : null,
                    leading: leading(context, state),
                    trailing: IgnorePointer(
                      child: ExpandIcon(
                        onPressed: (_) => onTap?.call(),
                        isExpanded: entry.isExpanded,
                      ),
                    ),
                    title: Text(
                      entry.category.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: entry.isExpanded
                                ? Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onAcceptWithDetails(DragTargetDetails details, BuildContext context) {
    if (details.data is Task) {
      context
          .read<TasksBloc>()
          .add(TaskStorageMoveTask(details.data, entry.category.uuid));
    }
  }

  Widget? leading(BuildContext context, SelectionState state) {
    if (!state.isSelecting || entry.category.numberOfChildren == 0) {
      return null;
    }
    return Checkbox(
      value: state.isCategorySelectedTristate(entry.category),
      tristate: true,
      onChanged: (value) =>
          context.read<SelectionCubit>().toggleCategory(entry.category),
    );
  }
}

class DummyHighPerfListingTile extends CategoryTile {
  DummyHighPerfListingTile({super.key}) : super(entry: ListingEntryCategory());
}
