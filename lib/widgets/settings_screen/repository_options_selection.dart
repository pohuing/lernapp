import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/model/preferences/repository_configuration/hive_repository_configuration.dart';
import 'package:lernapp/widgets/general_purpose/adaptive_alert_dialog.dart';

import 'export_native.dart' if (dart.library.html) 'export_web.dart'
    as export_mp;

class RepositoryOptionsSelection extends StatelessWidget {
  const RepositoryOptionsSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesStateBase>(
      builder: (context, state) => ExpansionTile(
        title: const Text('Data source'),
        children: [
          ...state.repositorySettings.configurations.map(
            (e) => RadioListTile(
              title: Text(e.title),
              controlAffinity: ListTileControlAffinity.platform,
              value: e,
              groupValue: state.repositorySettings.currentConfiguration,
              onChanged: (value) => context
                  .read<PreferencesBloc>()
                  .add(ChangeRepositoryConfiguration(e)),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.add),
            title: Text('Add configuration'),
            onTap: _showConfigurationCreationScreen,
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Reset storage'),
            subtitle: const Text(
              'Delete all your loaded tasks as well as entered solutions',
            ),
            onTap: () async => showDialog(
              context: context,
              builder: (context) => AdaptiveAlertDialog(
                title: 'Are you sure?',
                confirmChild: const Text('Delete'),
                content: const Text(
                  'This will delete all tasks as well as answers!',
                ),
                onConfirm: () async {
                  context.read<TasksBloc>().add(TaskStorageWipe());
                  context.pop();
                },
              ),
            ),
          ),
          if (state.repositorySettings.currentConfiguration
              is HiveRepositoryConfiguration)
            ListTile(
              leading: const Icon(Icons.import_export),
              title: const Text('Export'),
              subtitle: const Text('Export current storage to file'),
              onTap: () => export_mp.export(
                context,
                'lernapp_export',
                appendTimestamp: true,
              ),
            ),
          ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Save'),
            subtitle: const Text(
              'This should happen automatically in the background',
            ),
            onTap: () => context.read<TasksBloc>().add(TaskStorageSave()),
          ),
        ],
      ),
    );
  }
}

void _showConfigurationCreationScreen() {}
