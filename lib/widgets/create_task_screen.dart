import 'package:flutter/material.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/widgets/task_screen/solution_card.dart';
import 'package:lernapp/widgets/task_screen/task_card.dart';

class CreateTaskDialog extends StatefulWidget {
  final Widget? Function(Task task)? secondaryAction;

  const CreateTaskDialog({super.key, this.secondaryAction});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();

  static Future<Task?> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        return const Material(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CreateTaskDialog(),
          ),
        );
      },
    );
  }
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
    });
    taskController.addListener(() {
      setState(() {
        _taskContents = taskController.text;
      });
    });
    solutionTitleController.addListener(() {
      setState(() {
        _solutionTitle = solutionTitleController.text;
      });
    });
    solutionController.addListener(() {
      setState(() {
        _solutionContents = solutionController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          controller: scrollController,
          children: [
            TextFormField(
              controller: taskTitleController,
              decoration: const InputDecoration(
                label: Text('Task Title'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: taskController,
              minLines: 1,
              maxLines: 20,
              decoration: const InputDecoration(
                label: Text('Task'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: TaskCard(
                title: _taskTitle,
                description: _taskContents,
                showBackButton: false,
                secondaryAction: widget.secondaryAction?.call(task),
              ),
            ),
            TextFormField(
              controller: solutionTitleController,
              decoration: const InputDecoration(
                label: Text('Solution Title'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: solutionController,
              minLines: 1,
              maxLines: 20,
              decoration: const InputDecoration(
                label: Text('Solution'),
                border: OutlineInputBorder(),
              ),
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
}
