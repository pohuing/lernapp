import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/widgets/general_purpose/adaptive_alert_dialog.dart';

class RepositoryOptionsSelection extends StatefulWidget {
  const RepositoryOptionsSelection({super.key});

  @override
  State<RepositoryOptionsSelection> createState() =>
      _RepositoryOptionsSelectionState();
}

class _RepositoryOptionsSelectionState
    extends State<RepositoryOptionsSelection> {
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
                onConfirm: () async =>
                    context.read<TasksBloc>().add(TaskStorageWipe()),
              ),
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
