import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/repositories/task_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pick_or_save/pick_or_save.dart';

Future<void> export(
  BuildContext context,
  String filename, {
  bool appendTimestamp = false,
}) async {
  final repo = context.read<TasksBloc>().repository;
  if (appendTimestamp) {
    final now = DateTime.now();
    filename =
        '$filename ${DateFormat(DateFormat.YEAR_MONTH_DAY).format(now)} ${DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(now)}'
            .replaceAll(':', ' ');
  }

  if (repo is! HiveTaskRepository) {
    return;
  }
  final data = jsonEncode(repo.asMap());

  if (Platform.isWindows || Platform.isMacOS || Platform.isMacOS) {
    await _exportDesktop(data, filename);
  } else if (Platform.isAndroid) {
    await _exportAndroid(data, filename);
  } else if (Platform.isIOS) {
    await _exportIOS(data, filename);
  }
}

Future<void> _exportAndroid(String data, String filename) async {
  try {
    await PickOrSave().fileSaver(
      params: FileSaverParams(
        saveFiles: [
          SaveFileInfo(
            fileName: '$filename.json',
            fileData: Uint8List.fromList(utf8.encode(data)),
          ),
        ],
      ),
    );
  } catch (e) {
    log(e.toString(), name: '_exportAndroid');
  }
}

Future<void> _exportIOS(String data, String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final f = File(
    '${dir.path}/$filename.json',
  );
  try {
    await f.create();
    await f.writeAsString(data);
  } catch (e) {
    log(e.toString(), name: '_exportIOS');
  }
}

Future<void> _exportDesktop(String data, String filename) async {
  final path = await FilePicker.platform.saveFile(
    type: FileType.custom,
    allowedExtensions: ['json'],
    fileName: '$filename.json',
  );
  if (path == null) return;

  await File.fromUri(Uri(path: path)).writeAsString(data);
}
