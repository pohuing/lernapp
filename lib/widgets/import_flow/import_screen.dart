import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/logic/nullable_extensions.dart';
import 'package:lernapp/model/task_category.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/listing_screen/task_listing.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  String? fileName;
  String? fileContents;
  List<TaskCategory>? parsedContents;

  @override
  Widget build(BuildContext context) {
    return PlatformAdaptiveScaffold(
      title: 'Import',
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.file_open),
            title: const Text('Import'),
            subtitle: fileName.map((value) => const Text('value')),
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(
                allowedExtensions: ['json', 'txt'],
                allowMultiple: false,
                withReadStream: true,
              );
              if (result != null &&
                  result.names.isNotEmpty &&
                  result.files.first.readStream != null) {
                final file = result.files.first;
                final fileStream = file.readStream!;
                setState(() {
                  fileName = result.names.first;
                });
                try {
                  const jsonDecoder = JsonDecoder();
                  const utfDecoder = Utf8Decoder();
                  final conversionStream =
                      utfDecoder.fuse(jsonDecoder).bind(fileStream);
                  // ignore: unused_local_variable
                  final objects = await conversionStream
                      .cast<List>()
                      .map(
                        (event) => event
                            .map((e) => e as Map<String, dynamic>)
                            .toList(),
                      )
                      .toList();
                  log('deserialized objects: $objects', name: 'ImportScreen');
                  final categories = objects.first
                      .map(TaskCategory.fromMap)
                      .whereType<TaskCategory>()
                      .toList();
                  setState(() {
                    parsedContents = categories;
                  });
                } on FormatException catch (e) {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error parsing file'),
                      content: SingleChildScrollView(
                        child: Text(e.message),
                      ),
                    ),
                  );
                }
              }
            },
          ),
          if (parsedContents != null)
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Import loaded data'),
              subtitle: Text('This will overwrite existing data'),
              onTap: () {
                context.read<TasksBloc>()
                  ..add(TaskStorageImportCategories(parsedContents!))
                  ..add(TaskStorageLoad());
              },
            ),
          if (parsedContents != null)
            ExpansionTile(
              title: const Text('Result:'),
              children: [
                TaskListing(
                  categories: parsedContents!,
                  withNavBarStyle: true,
                  shrinkWrap: true,
                  clickableTasks: false,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
