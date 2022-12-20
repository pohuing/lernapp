import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final Function()? secondaryAction;
  final bool showBackButton;
  final bool? isExpanded;

  final _scrollController = ScrollController();

  TaskCard({
    super.key,
    required this.title,
    required this.description,
    this.secondaryAction,
    this.isExpanded,
    bool? showBackButton,
  })  : showBackButton = showBackButton ?? true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  if (showBackButton)
                    Expanded(
                      child: BackButton(
                        onPressed: () {
                          context.canPop()
                              ? context.pop()
                              : context.goNamed('listing');
                        },
                      ),
                    ),
                  if (secondaryAction != null)
                    Expanded(
                      child: ExpandIcon(
                        onPressed: (v) => secondaryAction!.call(),
                        isExpanded: isExpanded!,
                      ),
                    ),
                ],
              ),
              const VerticalDivider(width: 8),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: SelectableRegion(
                      focusNode: FocusNode(),
                      selectionControls:
                          defaultTargetPlatform == TargetPlatform.iOS
                              ? CupertinoTextSelectionControls()
                              : MaterialTextSelectionControls(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.bodyLarge,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
