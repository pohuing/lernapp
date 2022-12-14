import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/widgets/listing_screen/listing_screen.dart';

import 'repository_options_selection.dart';
import 'theme_settings_tile.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return PlatformAdativeScaffold(
      title: 'Preferences',
      previousTitle: 'Tasks',
      primary: true,
      body: Column(
        children: const [
          RepositoryOptionsSelection(),
          ThemeSettingsTile(),
        ],
      ),
    );
  }
}
