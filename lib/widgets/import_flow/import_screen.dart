import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/logic/import/file_reading.dart';
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
            subtitle: fileName.map((value) => Text(value)),
            onTap: loadFiles,
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
              key: Key(parsedContents.hashCode.toString()),
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

  Future<void> loadFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['json', 'txt'],
      allowMultiple: false,
      withData: true,
      type: FileType.custom,
    );
    if (result != null &&
        result.names.isNotEmpty &&
        result.files.first.bytes != null) {
      final file = result.files.first;
      try {
        final categories = await readByteArrayToTaskCategory(file.bytes!);
        setState(() {
          parsedContents = categories;
          fileName = file.name;
        });
      } on FormatException catch (e) {
        log(e.toString(), name: 'ImportScreen');
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
  }
}
