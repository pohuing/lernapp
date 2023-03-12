import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/logic/list_extensions.dart';
import 'package:lernapp/model/color_pair.dart';
import 'package:lernapp/model/line.dart';
import 'package:lernapp/model/solution_state.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area.dart';
import 'package:lernapp/widgets/general_purpose/color_selection/color_picker_dialogue.dart';
import 'package:lernapp/widgets/general_purpose/color_selection/color_selection.dart';

import 'solution_card.dart';
import 'task_card.dart';

class TaskArea extends StatefulWidget {
  final bool? showBackButton;
  final Task task;
  final bool reviewStyle;

  const TaskArea({
    super.key,
    this.showBackButton,
    required this.task,
    bool? reviewStyle,
  }) : reviewStyle = reviewStyle ?? false;

  @override
  State<TaskArea> createState() => _TaskAreaState();
}

class _TaskAreaState extends State<TaskArea> {
  final DrawingAreaController controller = DrawingAreaController();
  late final Task task;
  late final TasksBloc tasksBloc;
  var expandedTopRow = false;
  final ColorSelectionController colorController =
      ColorSelectionController.standardColors();
  Duration expandDuration = const Duration(milliseconds: 200);
  List<Line> lines = [];
  bool showsHistory = false;
  static const double historyWidth = 180;
  int? selectedHistoryIndex;

  double getDrawingAreaHeight(double widgetHeight) {
    if (expandedTopRow) {
      return widgetHeight / 2;
    } else {
      return (widgetHeight / 6) * 5;
    }
  }

  Curve get expandAnimationCurve => Curves.easeInOutCubicEmphasized;

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
                    title: task.title,
                    secondaryAction: Expanded(
                      child: ExpandIcon(
                        isExpanded: expandedTopRow,
                        onPressed: (v) => setState(
                          () => expandedTopRow = !expandedTopRow,
                        ),
                      ),
                    ),
                    isExpanded: expandedTopRow,
                    description: task.description,
                    showBackButton: widget.showBackButton,
                  ),
                ),
                Expanded(
                  child: SolutionCard(
                    title: task.hint,
                    solution: task.solution,
                    onReveal: onRevealSolution,
                    revealed: widget.reviewStyle,
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
                  child: buildControls(),
                ),
                AnimatedPositioned(
                  // History
                  duration: expandDuration,
                  curve: expandAnimationCurve,
                  top: 0,
                  left: showsHistory ? 0 : -historyWidth,
                  width: historyWidth,
                  height: getDrawingAreaHeight(constraints.maxHeight),
                  child: buildHistory(),
                ),
                BlocBuilder<PreferencesBloc, PreferencesStateBase>(
                  builder: (context, state) =>
                      state.generalPreferences.showHistoryBeforeSolving ||
                              controller.isCorrecting
                          ? AnimatedPositioned(
                              // History button
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
                            )
                          : Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onRevealSolution(isFlipped) => setState(() {
        controller.isCorrecting |= isFlipped;
        updateColorController();
      });

  Widget buildControls() => SizedBox(
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
            AnimatedSize(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 200),
              child: ColorSelectionRow(controller: colorController),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: !controller.isCorrecting
                  ? IconButton(
                      tooltip: 'Add a new color',
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (context) => ColorPickerDialogue(
                            colorController: colorController,
                          ),
                        );
                        if (result is ColorPair) {
                          setState(() {
                            colorController.selectedIndex =
                                colorController.colors.length - 1;
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                    )
                  : Container(),
            ),
            Slider(
              min: 1,
              max: 20,
              value: controller.penSize,
              onChanged: (value) => setState(() {
                controller.penSize = value;
              }),
            )
          ],
        ),
      );

  Widget buildHistory() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8.0, top: 0),
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: task.solutions.length,
          primary: false,
          itemBuilder: (context, i) {
            // Show history in reversed order, newest first
            final index = task.solutions.length - i - 1;
            var solution = task.solutions[index];
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
                    : Theme.of(context).colorScheme.onSecondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: StreamBuilder(
                  stream: Stream.periodic(const Duration(minutes: 1)),
                  builder: (context, snapshot) => Text(
                    getHistoryTileTitle(solution),
                  ),
                ),
                subtitle: Text(subtitle),
                onTap: () {
                  setState(() {
                    lines = solution.lines.copy();
                    controller.isCorrecting |= solution.revealedSolution;
                    selectedHistoryIndex = index;
                    updateColorController();
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (!(task.solutions.lastOrNull?.lines.equals(lines) ?? false)) {
      task.solutions
          .add(SolutionState(lines, revealedSolution: controller.isCorrecting));
      tasksBloc.add(TaskStorageSaveTask(task));
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    task = widget.task;
    tasksBloc = context.read<TasksBloc>();
    controller.penSize =
        context.read<PreferencesBloc>().state.themePreferences.lineWidth;
    colorController.colorChanged =
        (newColor) => setState(() => controller.currentColor = newColor);
    if (widget.reviewStyle) {
      lines = task.mostRecentSolution!.lines;
      controller.isCorrecting = widget.reviewStyle;
      updateColorController();
    }
  }

  void updateColorController() {
    if (controller.isCorrecting) {
      colorController.removeAllColors();
      colorController.addColorPair(
        context.read<PreferencesBloc>().state.themePreferences.correctionColors,
      );
      colorController.selectedIndex = 0;
    } else {
      colorController.removeNonDefaultColors();
      for (final line in lines) {
        colorController.addColorPair(line.colors);
      }
      colorController.selectedIndex = 0;
    }
  }

  String getHistoryTileTitle(SolutionState solution) {
    final now = DateTime.now();
    final difference = now.difference(solution.timestamp);
    if (difference < const Duration(minutes: 1)) {
      return S.of(context).taskArea_differenceLessThanOneMinute;
    } else if (difference < const Duration(hours: 1)) {
      return S
          .of(context)
          .taskArea_differenceinminutesMinutesAgo(difference.inMinutes);
    } else if (difference < const Duration(days: 1)) {
      return S
          .of(context)
          .taskArea_differenceinhoursHoursAgo(difference.inHours);
    } else if (difference < const Duration(days: 365)) {
      return S.of(context).taskArea_differenceindaysDaysAgo(difference.inDays);
    } else {
      return S
          .of(context)
          .taskArea_differenceindays365YearsAgo(difference.inDays);
    }
  }
}

extension SelectionList on DrawingAreaController {
  List<bool> get selectionList =>
      List.generate(TapMode.values.length, (index) => index == tapMode.index);
}
