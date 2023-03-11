import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/logic/nullable_extensions.dart';
import 'package:lernapp/model/color_pair.dart';
import 'package:lernapp/widgets/general_purpose/color_selection/color_selection.dart';

/// Content for picking colors.
/// Values can be retrieved via .pop(value) or via a colorController
class ColorPickerDialogue extends StatefulWidget {
  final ColorSelectionController? colorController;
  final ColorPair? startingColors;

  const ColorPickerDialogue({
    super.key,
    this.colorController,
    this.startingColors,
  });

  @override
  State<ColorPickerDialogue> createState() => _ColorPickerDialogueState();
}

class _AdaptiveRowColumn extends StatelessWidget {
  final List<Widget> children;

  const _AdaptiveRowColumn({required this.children});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 750) {
      return Row(children: children);
    } else {
      return Column(children: children);
    }
  }
}

class _ColorPickerDialogueState extends State<ColorPickerDialogue> {
  Color darkThemeColor = Colors.red[400]!;
  Color brightThemeColor = Colors.red[900]!;
  bool dualColours = false;

  void finish() {
    widget.colorController?.colors.add(
      buildColorPair(),
    );
    Navigator.of(context, rootNavigator: false)
        .pop<ColorPair?>(buildColorPair());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).colorPickerDialog_title),
      actions: [
        OutlinedButton(
          onPressed: Navigator.of(context).pop,
          child: Text(S.of(context).cancel),
        ),
        FilledButton(
            onPressed: finish,
            child: Text(S.of(context).colorPickerDialog_confirm))
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile.adaptive(
            title: Text(S.of(context).colorPickerDialog_separateColorsTitle),
            value: dualColours,
            onChanged: (value) => setState(() => dualColours = value),
          ),
          _AdaptiveRowColumn(
            children: [
              SizedBox(
                width: 300,
                height: 488,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dualColours)
                      Text(
                        S.of(context).colorPickerDialog_brightThemeColourTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ColorPicker(
                      portraitOnly: true,
                      pickerColor: brightThemeColor,
                      onColorChanged: (Color value) {
                        setState(() {
                          brightThemeColor = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (dualColours) const SizedBox(height: 8, width: 8),
              if (dualColours)
                SizedBox(
                  width: 300,
                  height: 488,
                  child: Column(
                    children: [
                      Text(
                        S.of(context).colorPickerDialog_darkThemeColourTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ColorPicker(
                        portraitOnly: true,
                        pickerColor: darkThemeColor,
                        onColorChanged: (Color value) {
                          setState(() {
                            darkThemeColor = value;
                          });
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.startingColors.map(
      (value) {
        brightThemeColor = value.brightTheme;
        darkThemeColor = value.darkTheme;
        dualColours = brightThemeColor != darkThemeColor;
      },
    );
  }

  ColorPair buildColorPair() {
    return ColorPair(
      darkTheme: darkThemeColor,
      brightTheme: dualColours ? brightThemeColor : darkThemeColor,
    );
  }
}
