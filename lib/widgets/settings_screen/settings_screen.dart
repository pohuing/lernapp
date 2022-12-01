import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/widgets/settings_screen/theme_settings_tile.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Preferences'),
          ),
          const SliverToBoxAdapter(child: RepositoryOptionsSelection()),
          const SliverToBoxAdapter(child: ThemeSettingsTile()),
        ],
      ),
    );
  }
}

class RepositoryOptionsSelection extends StatefulWidget {
  const RepositoryOptionsSelection({Key? key}) : super(key: key);

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
              value: e,
              title: Text(e.title),
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
