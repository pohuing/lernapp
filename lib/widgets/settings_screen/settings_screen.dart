import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';

import 'repository_options_selection.dart';
import 'theme_settings_tile.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return PlatformAdaptiveScaffold(
      title: 'Preferences',
      previousTitle: 'Tasks',
      body: ListView(
        padding: EdgeInsets.zero,
        children: const [
          RepositoryOptionsSelection(),
          ThemeSettingsTile(),
        ],
      ),
    );
  }
}
