import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SolutionCard extends StatefulWidget {
  final String title;
  final String solution;
  final void Function(dynamic isFlipped)? onReveal;

  /// Instantly reveal solution, does not trigger [onReveal]
  final bool revealed;

  const SolutionCard({
    super.key,
    required this.title,
    required this.solution,
    this.onReveal,
    bool? revealed,
  }) : revealed = revealed ?? false;

  @override
  State<SolutionCard> createState() => _SolutionCardState();
}

class _SolutionCardState extends State<SolutionCard> {
  final _scrollController = ScrollController();
  bool revealSolution = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Card(
            key: Key(revealSolution.toString()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: revealSolution
                  ? SizedBox.expand(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.title.isNotEmpty)
                                MarkdownBody(
                                  data: widget.title,
                                  shrinkWrap: true,
                                ),
                              SizedBox(
                                height: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.fontSize ??
                                    10,
                              ),
                              Markdown(
                                padding: EdgeInsets.zero,
                                data: widget.solution,
                                shrinkWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Center(child: Icon(Icons.visibility)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    revealSolution = widget.revealed;
    super.initState();
  }

  void onTap() {
    if (revealSolution != true) {
      widget.onReveal?.call(true);
      setState(() {
        revealSolution = true;
      });
    }
  }
}
