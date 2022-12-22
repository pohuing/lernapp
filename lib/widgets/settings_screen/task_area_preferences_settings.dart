import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/model/color_pair.dart';
import 'package:lernapp/widgets/general_purpose/color_selection/color_picker_dialogue.dart';
import 'package:lernapp/widgets/general_purpose/halved_circle.dart';

class TaskAreaPreferencesSettings extends StatelessWidget {
  const TaskAreaPreferencesSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesStateBase>(
      builder: (context, state) => Column(
        children: [
          ListTile(
            title: const Text('Correction colors'),
            subtitle: const Text('Colors available after showing solution'),
            onTap: () async {
              final result = await showDialog<ColorPair?>(
                context: context,
                builder: (context) => ColorPickerDialogue(
                  startingColors: state.themePreferences.correctionColors,
                ),
              );
              if (result != null) {
                // StatelessWidgets can never be unmounted
                // ignore: use_build_context_synchronously
                context
                    .read<PreferencesBloc>()
                    .add(ChangeCorrectionColor(result));
              }
            },
            trailing: Padding(
              padding: const EdgeInsets.all(8.0),
              child: HalvedCircle(
                topLeft: state.themePreferences.correctionColors.darkTheme,
                bottomRight:
                    state.themePreferences.correctionColors.brightTheme,
              ),
            ),
          ),
          SwitchListTile.adaptive(
            title: const Text('Show history button before revealing solution'),
            value: state.generalPreferences.showHistoryBeforeSolving,
            onChanged: (value) => context.read<PreferencesBloc>().add(
                  ChangeShowHistory(value),
                ),
          ),
        ],
      ),
    );
  }
}
