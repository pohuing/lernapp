import 'package:flutter/material.dart';
import 'package:lernapp/main.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area_controller.dart';
import 'package:lernapp/widgets/general_purpose/color_selection/color_selection.dart';
import 'package:lernapp/widgets/task_screen/solution_card.dart';
import 'package:lernapp/widgets/task_screen/task_card.dart';
import 'package:uuid/uuid.dart';

import '../../model/task.dart';
import '../drawing_area/drawing_area.dart';
import '../general_purpose/flippable.dart';
import 'hint_card.dart';

class TaskScreen extends StatefulWidget {
  final UuidValue uuid;

  const TaskScreen({super.key, required this.uuid});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  DrawingAreaController controller = DrawingAreaController();
  ColorSelectionController colorController =
      ColorSelectionController.standardColors();
  late final Task? task;
  var expandedTopRow = false;
  Duration expandDuration = const Duration(milliseconds: 200);

  double get drawingAreaHeight {
    final screenHeight = MediaQuery.of(context).size.height;
    final appHeight = screenHeight -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top;
    if (expandedTopRow) {
      return appHeight / 2;
    } else {
      return (appHeight / 6) * 5;
    }
  }

  Curve get expandAnimationCurve => Curves.easeInOut;

  double get infoRowHeight {
    final screenHeight = MediaQuery.of(context).size.height;
    final appHeight = screenHeight -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top;
    if (expandedTopRow) {
      return appHeight / 2;
    } else {
      return appHeight / 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: task != null
            ? Column(
                children: [
                  AnimatedContainer(
                    duration: expandDuration,
                    height: infoRowHeight,
                    curve: expandAnimationCurve,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: task!.uuid,
                            transitionOnUserGestures: true,
                            child: TaskCard(
                              title: task!.title,
                              secondaryAction: () => setState(
                                () => expandedTopRow = !expandedTopRow,
                              ),
                              isExpanded: expandedTopRow,
                              description: task!.taskDescription,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Flippable(
                            front: HintCard(hint: task!.hint),
                            back: SolutionCard(solution: task!.solution),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: expandDuration,
                    height: drawingAreaHeight,
                    curve: expandAnimationCurve,
                    child: Stack(
                      children: [
                        ClipRect(
                          child: DrawingArea(
                            controller: controller,
                            onEdited: (lines) => task!.drawnLines = lines,
                            lines: task!.drawnLines,
                            showEraser: controller.tapMode == TapMode.erase,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: SizedBox(
                            child: Row(
                              children: [
                                ToggleButtons(
                                  isSelected: controller.selectionList,
                                  onPressed: (index) {
                                    setState(() {
                                      controller.tapMode =
                                          TapMode.values[index];
                                    });
                                  },
                                  children: const [
                                    Icon(
                                      Icons.draw,
                                    ),
                                    Icon(Icons.pan_tool),
                                    Icon(Icons.undo)
                                  ],
                                ),
                                ColorSelectionRow(controller: colorController),
                                Slider(
                                  min: 1,
                                  max: 10,
                                  value: controller.penSize,
                                  onChanged: (value) => setState(() {
                                    controller.penSize = value;
                                  }),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Text('Task with uuid ${widget.uuid} was not found in repository'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    task = taskRepository.findByUuid(widget.uuid);
    colorController.colorChanged = (newColor) => setState(() {
          controller.currentColor = newColor;
        });
    super.initState();
  }
}

extension SelectionList on DrawingAreaController {
  List<bool> get selectionList =>
      List.generate(TapMode.values.length, (index) => index == tapMode.index);
}
