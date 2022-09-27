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
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.colorController.colors.add(ColorPair(color, color));
            Navigator.of(context, rootNavigator: false).pop();
          },
          child: const Text('Confirm'),
        )
      ],
      content: ColorPicker(
        portraitOnly: true,
        pickerColor: color,
        onColorChanged: (Color value) {
          setState(() {
            color = value;
          });
        },
      ),
    );
  }
}
