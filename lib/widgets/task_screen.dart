import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/widgets/solution_card.dart';
import 'package:lernapp/widgets/task_card.dart';

import 'drawing_area.dart';
import 'flippable.dart';
import 'hint_card.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Hero(
                      tag: title,
                      child: TaskCard(
                        title: title,
                        onTap: () => context.pop(),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Flippable(
                      front: HintCard(),
                      back: SolutionCard(),
                    ),
                  ),
                ],
              ),
            ),
            const Flexible(
              flex: 5,
              child: ClipRect(child: DrawingArea()),
            ),
          ],
        ),
      ),
    );
  }
}
