import 'package:flutter/material.dart';
import 'package:lernapp/main.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area_controller.dart';
import 'package:lernapp/widgets/general_purpose/color_selection/color_picker_dialogue.dart';
import 'package:lernapp/widgets/general_purpose/color_selection/color_selection.dart';
import 'package:lernapp/widgets/task_screen/solution_card.dart';
import 'package:lernapp/widgets/task_screen/task_card.dart';
import 'package:uuid/uuid.dart';

import '../../model/task.dart';
import '../drawing_area/drawing_area.dart';
import '../general_purpose/flippable.dart';
import 'hint_card.dart';

class TaskArea extends StatefulWidget {
  final UuidValue uuid;

  final bool? showBackButton;

  const TaskArea({super.key, required this.uuid, this.showBackButton});

  @override
  State<TaskArea> createState() => _TaskAreaState();
}

class _TaskAreaState extends State<TaskArea> {
  DrawingAreaController controller = DrawingAreaController();
  late final Task? task;
  var expandedTopRow = false;
  ColorSelectionController colorController =
      ColorSelectionController.standardColors();
  Duration expandDuration = const Duration(milliseconds: 200);

  double getDrawingAreaHeight(double widgetHeight) {
    if (expandedTopRow) {
      return widgetHeight / 2;
    } else {
      return (widgetHeight / 6) * 5;
    }
  }

  Curve get expandAnimationCurve => Curves.easeInOut;

  double getInfoRowHeight(double widgetHeight) {
    if (expandedTopRow) {
      return widgetHeight / 2;
    } else {
      return widgetHeight / 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          AnimatedContainer(
            duration: expandDuration,
            height: getInfoRowHeight(constraints.maxHeight),
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
                      showBackButton: widget.showBackButton,
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
            height: getDrawingAreaHeight(constraints.maxHeight),
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
                              controller.tapMode = TapMode.values[index];
                            });
                          },
                          children: const [
                            Icon(Icons.draw),
                            Icon(Icons.pan_tool),
                            Icon(Icons.undo)
                          ],
                        ),
                        ColorSelectionRow(controller: colorController),
                        IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => ColorPickerDialogue(
                                colorController: colorController,
                              ),
                            );
                            setState(() {});
                          },
                          icon: const Icon(Icons.add),
                        ),
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
    for (var line in task!.drawnLines) {
      colorController.addColorPair(line.colors);
    }
    colorController.colorChanged =
        (newColor) => setState(() => controller.currentColor = newColor);
    super.initState();
  }
}

extension SelectionList on DrawingAreaController {
  List<bool> get selectionList =>
      List.generate(TapMode.values.length, (index) => index == tapMode.index);
}
