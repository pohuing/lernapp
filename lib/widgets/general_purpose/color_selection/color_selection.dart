import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/model/pair.dart';
import 'package:system_theme/system_theme.dart';

import '../halved_circle.dart';

typedef ColorPair = Pair<Color>;

class ColorSelectionController {
  void Function(ColorPair newColor)? colorChanged;
  List<ColorPair> colors;
  int _selectedIndex;

  ColorSelectionController(
    this.colors,
    this._selectedIndex, {
    this.colorChanged,
  });

  /// A selection of color pairs
  ColorSelectionController.standardColors({
    this.colorChanged,
  })  : colors = [],
        _selectedIndex = 0 {
    colors = [
      ColorPair(Colors.white, Colors.black),
    ];
    selectedIndex = 0;
  }

  List<Color> get activePalette =>
      colors.map((e) => SystemTheme.isDarkMode ? e.one : e.two).toList();

  Color get selectedColor {
    if (SystemTheme.isDarkMode) {
      return colors[selectedIndex].one;
    } else {
      return colors[selectedIndex].two;
    }
  }

  int get selectedIndex => _selectedIndex;

  set selectedIndex(value) {
    _selectedIndex = value;
    colorChanged?.call(selectedPair);
  }

  ColorPair get selectedPair => colors[selectedIndex];

  List<bool> get selectionList =>
      List.generate(colors.length, (index) => index == selectedIndex);

  /// Adds a new colour pair
  ///
  /// Does nothing if [pair] is already in [colors]
  void addColorPair(ColorPair pair) {
    if (colors.none(
      (p0) => p0 == pair,
    )) {
      colors.add(pair.copy());
    }
  }
}

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
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: controller.selectionList,
      onPressed: (i) => setState(() => controller.selectedIndex = i),
      children: [
        ...controller.colors.map(
          (e) => Container(
            height: widget.height ?? 24,
            margin: const EdgeInsets.all(8),
            child: HalvedCircle(a: e.one, b: e.two),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    controller = widget.controller ?? ColorSelectionController.standardColors();
    super.initState();
  }
}
