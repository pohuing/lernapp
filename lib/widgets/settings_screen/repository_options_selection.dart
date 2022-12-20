import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';

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
          )
        ],
      ),
    );
  }
}

void _showConfigurationCreationScreen() {}
