import 'package:flutter/material.dart';
import 'package:lernapp/model/pair.dart';
import 'package:system_theme/system_theme.dart';

typedef ColorPair = Pair<Color>;

class ColorSelectionRow extends StatefulWidget {
  final ColorSelectionController? controller;
  final double? height;

  const ColorSelectionRow({Key? key, this.controller, this.height})
      : super(key: key);

  @override
  State<ColorSelectionRow> createState() => _ColorSelectionRowState();
}

class _ColorSelectionRowState extends State<ColorSelectionRow> {
  late final ColorSelectionController controller;

  @override
  void initState() {
    controller = widget.controller ?? ColorSelectionController.standardColors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: controller.selectionList,
      onPressed: (i) => setState(() => controller.selectedIndex = i),
      children: [
        ...controller.activePalette.map(
          (e) => Container(
            height: widget.height ?? 24,
            margin: const EdgeInsets.all(8),
            child: Circle(color: e),
          ),
        ),
      ],
    );
  }
}

class Circle extends StatelessWidget {
  final Color color;

  const Circle({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class ColorSelectionController {
  void Function(Color newColor)? colorChanged;
  void Function(int index, Color color)? selectionChanged;
  List<ColorPair> colors;
  int selectedIndex;

  ColorSelectionController(
    this.colors,
    this.selectedIndex, {
    this.colorChanged,
    this.selectionChanged,
  });

  /// A selection of color pairs
  ColorSelectionController.standardColors({
    this.colorChanged,
    this.selectionChanged,
  })  : colors = [],
        selectedIndex = 0 {
    colors = [
      ColorPair(Colors.white, Colors.black),
      ColorPair(Colors.red, Colors.redAccent)
    ];
    selectedIndex = 0;
  }

  List<bool> get selectionList =>
      List.generate(colors.length, (index) => index == selectedIndex);

  List<Color> get activePalette =>
      colors.map((e) => SystemTheme.isDarkMode ? e.one : e.two).toList();

  Color get selectedColor {
    if (SystemTheme.isDarkMode) {
      return colors[selectedIndex].one;
    } else {
      return colors[selectedIndex].two;
    }
  }
}
