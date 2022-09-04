import 'package:flutter/material.dart';
import 'package:flutter_ameno_ipsum/flutter_ameno_ipsum.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area_controller.dart';
import 'package:lernapp/widgets/solution_card.dart';
import 'package:lernapp/widgets/task_card.dart';

import 'drawing_area/drawing_area.dart';
import 'flippable.dart';
import 'hint_card.dart';

class TaskScreen extends StatefulWidget {
  final String title;

  const TaskScreen(this.title, {super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  DrawingAreaController controller = DrawingAreaController();

  final toggleButtonState = [true, false, false];

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
                      tag: widget.title,
                      child: TaskCard(
                        title: widget.title,
                        description: ameno(paragraphs: 2, words: 20),
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
            Flexible(
              flex: 5,
              child: Stack(
                children: [
                  ClipRect(
                    child: DrawingArea(
                      controller: controller,
                    ),
                  ),
                  Positioned(
                    child: ToggleButtons(
                      isSelected: toggleButtonState,
                      onPressed: (index) {
                        controller.tapMode = TapMode.values[index];
                        setState(() {
                          for (var i = 0; i < toggleButtonState.length; ++i) {
                            toggleButtonState[i] = i == index;
                          }
                        });
                      },
                      children: const [
                        Icon(Icons.draw),
                        Icon(Icons.pan_tool),
                        Icon(Icons.undo)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
