import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';

class ThemeSettingsTile extends StatefulWidget {
  const ThemeSettingsTile({super.key});

  @override
  State<ThemeSettingsTile> createState() => _ThemeSettingsTileState();
}

class _ThemeSettingsTileState extends State<ThemeSettingsTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Visual'),
      children: [
        BlocBuilder<PreferencesBloc, PreferencesStateBase>(
          builder: (context, state) {
            return Column(
              children: [
                SwitchListTile.adaptive(
                  title: const Text('Enable blend AA'),
                  subtitle: const Text(
                    'Apply anti-aliasing when blending layers, minor performance impact',
                  ),
                  value: state.themePreferences.blendAA,
                  onChanged: (value) =>
                      context.read<PreferencesBloc>().add(ChangeBlendAA(value)),
                ),
                SwitchListTile.adaptive(
                  title: const Text('Enable Paint AA'),
                  subtitle: const Text(
                    'Apply anti-aliasing when drawing lines, major performance impact',
                  ),
                  value: state.themePreferences.paintAA,
                  isThreeLine: true,
                  onChanged: (value) =>
                      context.read<PreferencesBloc>().add(ChangePaintAA(value)),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
