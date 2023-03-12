import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget? secondaryAction;
  final bool showBackButton;
  final bool isExpanded;

  final _scrollController = ScrollController();

  TaskCard({
    super.key,
    required this.title,
    required this.description,
    this.secondaryAction,
    bool? isExpanded,
    bool? showBackButton,
  })  : isExpanded = isExpanded ?? false,
        showBackButton = showBackButton ?? true;

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
                mainAxisSize: MainAxisSize.min,
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
                  if (secondaryAction != null) secondaryAction!,
                ],
              ),
              if (showBackButton || secondaryAction != null)
                const VerticalDivider(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title.isNotEmpty)
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.start,
                          ),
                        Markdown(
                          padding: EdgeInsets.zero,
                          data: description,
                          shrinkWrap: true,
                        ),
                      ],
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
