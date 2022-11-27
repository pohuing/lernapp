import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/logic/list_extensions.dart';
import 'package:lernapp/model/line.dart';
import 'package:lernapp/model/solution_state.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area.dart';
import 'package:lernapp/widgets/general_purpose/color_selection/color_picker_dialogue.dart';
import 'package:lernapp/widgets/general_purpose/color_selection/color_selection.dart';
import 'package:lernapp/widgets/general_purpose/flippable.dart';

import 'hint_card.dart';
import 'solution_card.dart';
import 'task_card.dart';

class TaskArea extends StatefulWidget {
  final bool? showBackButton;
  final Task? task;

  const TaskArea({super.key, this.showBackButton, this.task});

  @override
  State<TaskArea> createState() => _TaskAreaState();
}

class _TaskAreaState extends State<TaskArea> {
  DrawingAreaController controller = DrawingAreaController();
  late final Task? task;
  late final TasksBloc tasksBloc;
  var expandedTopRow = false;
  ColorSelectionController colorController =
      ColorSelectionController.standardColors();
  Duration expandDuration = const Duration(milliseconds: 200);
  List<Line> lines = [];
  bool showsHistory = false;
  final double historyWidth = 180;
  int? selectedHistoryIndex;

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
                  child: TaskCard(
                    title: task!.title,
                    secondaryAction: () => setState(
                      () => expandedTopRow = !expandedTopRow,
                    ),
                    isExpanded: expandedTopRow,
                    description: task!.description,
                    showBackButton: widget.showBackButton,
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
                    onEdited: (lines) => this.lines = lines,
                    lines: lines,
                    showEraser: controller.tapMode == TapMode.erase,
                  ),
                ),
                AnimatedPositioned(
                  duration: expandDuration,
                  curve: expandAnimationCurve,
                  top: 0,
                  left: 4 + (showsHistory ? historyWidth : 0),
                  child: SizedBox(
                    child: Row(
                      children: [
                        ToggleButtons(
                          borderRadius: BorderRadius.circular(12),
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
                            final colourChanged = await showDialog(
                              context: context,
                              builder: (context) => ColorPickerDialogue(
                                colorController: colorController,
                              ),
                            );
                            if (colourChanged is bool && colourChanged) {
                              setState(() {
                                colorController.selectedIndex =
                                    colorController.colors.length - 1;
                              });
                            }
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
                ),
                AnimatedPositioned(
                  duration: expandDuration,
                  curve: expandAnimationCurve,
                  top: 0,
                  left: showsHistory ? 0 : -historyWidth,
                  width: historyWidth,
                  height: getDrawingAreaHeight(constraints.maxHeight),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 4, bottom: 8.0, top: 0),
                    child: Material(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: task?.solutions.length ?? 0,
                        primary: false,
                        itemBuilder: (context, index) {
                          var solution = task!.solutions[index];
                          var subtitle =
                              '${solution.timestamp.hour}:${solution.timestamp.minute} ${solution.timestamp.day}.${solution.timestamp.month}.${solution.timestamp.year}';
                          return Container(
                            margin: const EdgeInsets.all(4),
                            child: ListTile(
                              tileColor: index == selectedHistoryIndex
                                  ? Theme.of(context).colorScheme.secondary
                                  : null,
                              textColor: index == selectedHistoryIndex
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: StreamBuilder(
                                stream:
                                    Stream.periodic(const Duration(minutes: 1)),
                                builder: (context, snapshot) => Text(
                                  getHistoryTileTitle(solution),
                                ),
                              ),
                              subtitle: Text(subtitle),
                              onTap: () {
                                setState(() {
                                  lines = solution.lines.copy();
                                  selectedHistoryIndex = index;
                                  updateColorController();
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: expandDuration,
                  curve: expandAnimationCurve,
                  bottom: 4,
                  left: 4 + (showsHistory ? historyWidth : 0),
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      setState(() {
                        showsHistory = !showsHistory;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (!(task?.solutions.lastOrNull?.lines.equals(lines) ?? false)) {
      task?.solutions.add(SolutionState(lines));
      tasksBloc.add(TaskStorageSaveTask(task!));
    }
    super.dispose();
  }

  @override
  void initState() {
    task = widget.task;
    tasksBloc = context.read<TasksBloc>();
    if (task!.solutions.isNotEmpty) {
      for (var line in task!.solutions.last.lines) {
        lines.add(line);
      }
    }
    updateColorController();
    colorController.colorChanged =
        (newColor) => setState(() => controller.currentColor = newColor);
    super.initState();
  }

  void updateColorController() {
    colorController.removeNonDefaultColors();
    for (final line in lines) {
      colorController.addColorPair(line.colors);
    }
  }

  String getHistoryTileTitle(SolutionState solution) {
    final now = DateTime.now();
    final difference = now.difference(solution.timestamp);
    if (difference < const Duration(hours: 1)) {
      return '${difference.inMinutes} Minutes ago';
    } else if (difference < const Duration(days: 1)) {
      return '${difference.inHours} Hours ago';
    } else if (difference < const Duration(days: 365)) {
      return '${difference.inDays} Days ago';
    } else {
      return '${difference.inDays / 365} Years ago';
    }
  }
}

extension SelectionList on DrawingAreaController {
  List<bool> get selectionList =>
      List.generate(TapMode.values.length, (index) => index == tapMode.index);
}
