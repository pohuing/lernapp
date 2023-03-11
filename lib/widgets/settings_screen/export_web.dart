// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' show AnchorElement;

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/repositories/task_repository.dart';

Future<void> export(BuildContext context, String filename) async {
  final repo = context.read<TasksBloc>().repository;
  if (repo is! HiveTaskRepository) {
    return;
  }
  final data = jsonEncode(repo.asMap());
  AnchorElement()
    ..href = Uri.dataFromString(data, mimeType: 'text/json', encoding: utf8)
        .toString()
    ..download = '$filename.json'
    ..style.display = 'none'
    ..click()
    ..remove();
}