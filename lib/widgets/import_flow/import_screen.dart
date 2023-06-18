import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_schema2/json_schema.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/logic/import/file_reading.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/logic/nullable_extensions.dart';
import 'package:lernapp/model/task_category.dart';
import 'package:lernapp/widgets/general_purpose/adaptive_alert_dialog.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/general_purpose/timed_snackbar.dart';
import 'package:lernapp/widgets/listing_screen/task_listing.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => ImportScreenState();
}

/// This state is public to allow injecting file contents in integration tests
class ImportScreenState extends State<ImportScreen> {
  String? fileName;
  String? fileContents;
  List<TaskCategory>? parsedContents;

  @override
  Widget build(BuildContext context) {
    return PlatformAdaptiveScaffold(
      title: S.of(context).importScreen_title,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.file_open),
            title: Text(S.of(context).importScreen_importTileTitle),
            subtitle: fileName.map((value) => Text(value)),
            onTap: tapImport,
          ),
          if (parsedContents != null)
            ListTile(
              leading: const Icon(Icons.check),
              title: Text(S.of(context).importScreen_importActionTitle),
              subtitle: Text(S.of(context).importScreen_importActionWarning),
              onTap: () {
                context.read<TasksBloc>()
                  ..add(TaskStorageImportCategories(parsedContents!))
                  ..add(TaskStorageLoad());
                showTimedSnackBar(
                  context,
                  S.of(context).importScreen_importConfirmation,
                );
              },
            ),
          if (parsedContents != null)
            ExpansionTile(
              key: Key(parsedContents.hashCode.toString()),
              title: Text(S.of(context).importScreen_previewTitle),
              children: [
                BlocProvider(
                  create: (context) => SelectionCubit(),
                  child: TaskListing(
                    showMostRecent: true,
                    categories: parsedContents!,
                    shrinkWrap: true,
                    clickableTasks: false,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> tapImport() async {
    final file = await loadFile();
    if (file?.bytes case Uint8List bytes when file != null) {
      await parseContents(await prepareString(bytes), file.name);
    }
  }

  Future<void> parseContents(String contents, String fileName) async {
    try {
      await validateJson(contents);
      final categories = await readStringToTaskCategory(contents);
      setState(() {
        parsedContents = categories;
        fileName = fileName;
      });
    } on FormatException catch (e) {
      log(e.toString(), name: 'ImportScreen');
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AdaptiveAlertDialog(
            title: 'Error parsing file',
            content: Column(
              children: [
                Text(e.message),
                Text(e.toString()),
              ],
            ),
          ),
        );
      }
    }
  }

  Future<PlatformFile?> loadFile() async {
    if (!kIsWeb && Platform.isAndroid) {
      await FilePicker.platform.clearTemporaryFiles();
    }
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
      return file;
    }

    return null;
  }

  Future<bool> validateJson(String json) async {
    final schema = await rootBundle.loadString('assets/importSchema.json');
    final validator =
        JsonSchema.create(schema, schemaVersion: SchemaVersion.draft6);
    try {
      final result = validator.validate(json, parseJson: true);
      if (!result.isValid) {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Data does not adhere to the spec'),
                content: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectionArea(
                      child: Column(
                        children: [
                          ...result.errors
                              .map((e) => [Text(e.message), const Divider()])
                              .flattened
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return false;
      }
    } catch (e) {
      log(
        'Error validating file: ${e.toString()}',
        name: 'ImportScreen.validateJson',
      );
      return false;
    }

    return true;
  }
}
