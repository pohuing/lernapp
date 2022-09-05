import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;

  final _scrollController = ScrollController();

  TaskCard({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButton(
                onPressed: () {
                  context.canPop() ? context.pop() : context.goNamed('listing');
                },
              ),
              const VerticalDivider(width: 8),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: SelectableRegion(
                      focusNode: FocusNode(),
                      selectionControls:
                          defaultTargetPlatform == TargetPlatform.iOS
                              ? CupertinoTextSelectionControls()
                              : MaterialTextSelectionControls(),
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
            ],
          ),
        ),
      ),
    );
  }
}
