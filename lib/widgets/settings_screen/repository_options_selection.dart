import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/generated/l10n.dart';
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
        title: Text(S.of(context).repositoryOptionsSelection_sectionTitle),
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
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(
              S.of(context).repositoryOptionsSelection_addConfigurationTitle,
            ),
            onTap: _showConfigurationCreationScreen,
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: Text(
              S.of(context).repositoryOptionsSelection_resetStorageTitle,
            ),
            subtitle: Text(
              S.of(context).repositoryOptionsSelection_resetStorageDescription,
            ),
            onTap: () async => showDialog(
              context: context,
              builder: (context) => AdaptiveAlertDialog(
                title: S
                    .of(context)
                    .repositoryOptionsSelection_resetConfirmationDialogTitle,
                confirmChild: const Text('Delete'),
                content: Text(
                  S
                      .of(context)
                      .repositoryOptionsSelection_resetConfirmationDialogWarning,
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
              title: Text(S.of(context).repositoryOptionsSelection_exportTitle),
              subtitle: Text(
                S.of(context).repositoryOptionsSelection_exportDescription,
              ),
              onTap: () => export_mp.export(
                context,
                'lernapp_export',
                appendTimestamp: true,
              ),
            ),
          ListTile(
            leading: const Icon(Icons.save),
            title: Text(S.of(context).repositoryOptionsSelection_saveTitle),
            subtitle: Text(
              S.of(context).repositoryOptionsSelection_saveDescription,
            ),
            onTap: () => context.read<TasksBloc>().add(TaskStorageSave()),
          ),
        ],
      ),
    );
  }
}

void _showConfigurationCreationScreen() {}
