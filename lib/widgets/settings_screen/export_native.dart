import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/repositories/task_repository.dart';

Future<void> export(BuildContext context, String filename) async {
  final repo = context.read<TasksBloc>().repository;

  final path = await FilePicker.platform.saveFile(
    type: FileType.custom,
    allowedExtensions: ['json'],
    fileName: '$filename.json',
  );
  if (path == null) return;
  if (repo is! HiveTaskRepository) {
    return;
  }
  final data = jsonEncode(repo.asMap());
  await File.fromUri(Uri(path: path)).writeAsString(data);
}
