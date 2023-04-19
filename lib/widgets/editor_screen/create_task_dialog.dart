import 'package:flutter/material.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/widgets/task_screen/solution_card.dart';
import 'package:lernapp/widgets/task_screen/task_card.dart';

class CreateTaskDialog extends StatefulWidget {
  final Widget? Function(Task task)? secondaryAction;
  final void Function(Task? task)? onChange;

  const CreateTaskDialog({super.key, this.secondaryAction, this.onChange});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final taskTitleController = TextEditingController();
  final taskController = TextEditingController();
  final solutionTitleController = TextEditingController();
  final solutionController = TextEditingController();
  final scrollController = ScrollController();

  String _taskTitle = '';
  String _taskContents = '';
  String _solutionTitle = '';
  String _solutionContents = '';

  Task get task =>
      Task(_taskTitle, _taskContents, _solutionTitle, _solutionContents);

  @override
  void initState() {
    super.initState();
    taskTitleController.addListener(() {
      setState(() {
        _taskTitle = taskTitleController.text;
      });
      widget.onChange?.call(task);
    });
    taskController.addListener(() {
      setState(() {
        _taskContents = taskController.text;
      });
      widget.onChange?.call(task);
    });
    solutionTitleController.addListener(() {
      setState(() {
        _solutionTitle = solutionTitleController.text;
      });
      widget.onChange?.call(task);
    });
    solutionController.addListener(() {
      setState(() {
        _solutionContents = solutionController.text;
      });
      widget.onChange?.call(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        child: ListView(
          controller: scrollController,
          children: [
            const SizedBox(height: 8),
            TextFormField(
              controller: taskTitleController,
              decoration: InputDecoration(
                label: Text(S.of(context).createTaskScreen_taskTitleLabel),
                border: const OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value?.isEmpty ?? true) && _taskContents.isEmpty
                      ? 'Missing text'
                      : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: taskController,
              minLines: 1,
              maxLines: 20,
              decoration: InputDecoration(
                label:
                    Text(S.of(context).createTaskScreen_taskDescriptionLabel),
                border: const OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value?.isEmpty ?? true) && _taskTitle.isEmpty
                      ? 'Missing text'
                      : null,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: TaskCard(
                title: _taskTitle,
                body: _taskContents,
                showBackButton: false,
                secondaryAction: widget.secondaryAction?.call(task),
              ),
            ),
            TextFormField(
              controller: solutionTitleController,
              decoration: InputDecoration(
                label: Text(S.of(context).createTaskScreen_solutionTitleLabel),
                border: const OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value?.isEmpty ?? true) && _solutionContents.isEmpty
                      ? 'Missing text'
                      : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: solutionController,
              minLines: 1,
              maxLines: 20,
              decoration: InputDecoration(
                label: Text(
                  S.of(context).createTaskScreen_solutionDescriptionLabel,
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value?.isEmpty ?? true) && _solutionTitle.isEmpty
                      ? 'Missing text'
                      : null,
            ),
            SizedBox(
              height: 300,
              child: SolutionCard(
                title: _solutionTitle,
                solution: _solutionContents,
                revealed: true,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    taskTitleController.dispose();
    taskController.dispose();
    solutionTitleController.dispose();
    solutionController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
