import 'package:flutter/material.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/widgets/task_screen/solution_card.dart';
import 'package:lernapp/widgets/task_screen/task_card.dart';

class CreateTaskDialog extends StatefulWidget {
  const CreateTaskDialog({super.key});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();

  static Future<Task?> show(BuildContext context) async {
    return await showGeneralDialog<Task?>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const CreateTaskDialog();
      },
    );
  }
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final taskTitleController = TextEditingController();
  final taskController = TextEditingController();
  final solutionTitleController = TextEditingController();
  final solutionController = TextEditingController();

  String taskTitle = '';
  String task = '';
  String solutionTitle = '';
  String solution = '';

  @override
  void initState() {
    super.initState();
    taskTitleController.addListener(() {
      setState(() {
        taskTitle = taskTitleController.text;
      });
    });
    taskController.addListener(() {
      setState(() {
        task = taskController.text;
      });
    });
    solutionTitleController.addListener(() {
      setState(() {
        solutionTitle = solutionTitleController.text;
      });
    });
    solutionController.addListener(() {
      setState(() {
        solution = solutionController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: taskTitleController,
              decoration: InputDecoration(
                label: Text(S.of(context).createTaskScreen_taskTitleLabel),
                border: const OutlineInputBorder(),
              ),
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
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: solutionTitleController,
              decoration: InputDecoration(
                label: Text(S.of(context).createTaskScreen_solutionTitleLabel),
                border: const OutlineInputBorder(),
              ),
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
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TaskCard(
                      title: taskTitle,
                      description: task,
                    ),
                  ),
                  Expanded(
                    child: SolutionCard(
                      title: solutionTitle,
                      solution: solution,
                      revealed: true,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
