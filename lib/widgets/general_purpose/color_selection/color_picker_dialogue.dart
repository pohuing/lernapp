import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lernapp/widgets/general_purpose/color_selection/color_selection.dart';

class ColorPickerDialogue extends StatefulWidget {
  final ColorSelectionController colorController;

  const ColorPickerDialogue({Key? key, required this.colorController})
      : super(key: key);

  @override
  State<ColorPickerDialogue> createState() => _ColorPickerDialogueState();
}

class _ColorPickerDialogueState extends State<ColorPickerDialogue> {
  Color darkThemeColor = Colors.red[400]!;
  Color brightThemeColor = Colors.red[900]!;
  bool dualColours = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Add a new Color'),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.colorController.colors.add(
              ColorPair(darkThemeColor,
                  !dualColours ? darkThemeColor : brightThemeColor),
            );
            Navigator.of(context, rootNavigator: false).pop(true);
          },
          child: const Text('Confirm'),
        )
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: const Text('Use separate colors'),
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
                        'Bright Theme Colour',
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
              ),
              if (dualColours)
                SizedBox(
                  width: 300,
                  height: 488,
                  child: Column(
                    children: [
                      Text(
                        'Dark Theme Colour',
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
                )
            ],
          ),
        ],
      ),
    );
  }
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
