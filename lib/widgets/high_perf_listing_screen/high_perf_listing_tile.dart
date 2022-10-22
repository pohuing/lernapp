import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/model/high_performance_listing_wrappers.dart';

import '../../blocs/selection_cubit.dart';

class HighPerfListingTile extends StatelessWidget {
  final ListingEntryCategory entry;
  final Function()? onTap;

  const HighPerfListingTile({Key? key, required this.entry, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: entry.depth * 16),
      child: BlocBuilder<SelectionCubit, SelectionState>(
        builder: (context, state) => Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: BorderDirectional(
                  start: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                  bottom: entry.isExpanded
                      ? BorderSide.none
                      : BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: ListTile(
                onTap: () {
                  onTap?.call();
                },
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
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                ),
              ),
            ),
            if (entry.isExpanded)
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
    );
  }

  Widget? leading(BuildContext context, SelectionState state) {
    if (!state.isSelecting || entry.category.numberOfChildren == 0) {
      return null;
    }
    return Checkbox(
      value: state.entireCategoryIsSelected(entry.category),
      onChanged: (value) =>
          context.read<SelectionCubit>().toggleCategory(entry.category),
    );
  }
}

class DummyHighPerfListingTile extends HighPerfListingTile {
  DummyHighPerfListingTile({Key? key})
      : super(key: key, entry: ListingEntryCategory());
}
