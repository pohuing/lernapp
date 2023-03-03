import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/model/high_performance_listing_wrappers.dart';

import '../../blocs/selection_cubit.dart';

class CategoryTile extends StatelessWidget {
  final ListingEntryCategory entry;
  final Function()? onTap;
  final bool asNavigationBarItem;

  const CategoryTile({
    super.key,
    required this.entry,
    this.onTap,
    bool? asNavigationBarItem,
  }) : asNavigationBarItem = asNavigationBarItem ?? false;

  Widget decoration(BuildContext context, {required Widget child}) {
    if (asNavigationBarItem) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: child,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(color: Theme.of(context).dividerColor),
            start: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        child: child,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.only(left: entry.depth * 16),
        child: BlocBuilder<SelectionCubit, SelectionState>(
          builder: (context, state) => Stack(
            children: [
              decoration(
                context,
                child: ListTile(
                  shape: asNavigationBarItem
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        )
                      : null,
                  onTap: () {
                    onTap?.call();
                  },
                  tileColor: entry.isExpanded && asNavigationBarItem
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
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
              if (entry.isExpanded && !asNavigationBarItem)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 16,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
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
