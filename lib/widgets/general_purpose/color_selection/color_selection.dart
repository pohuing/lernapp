import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/model/color_pair.dart';
import 'package:system_theme/system_theme.dart';

import '../halved_circle.dart';

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
    Iterable<ColorPair>? colors,
  })  : colors = [],
        _selectedIndex = 0 {
    this.colors = [
      ColorPair.defaultColors,
      ...?colors,
    ];
    selectedIndex = 0;
  }

  List<Color> get activePalette => colors
      .map((e) => SystemTheme.isDarkMode ? e.darkTheme : e.brightTheme)
      .toList();

  Color get selectedColor {
    if (SystemTheme.isDarkMode) {
      return colors[selectedIndex].darkTheme;
    } else {
      return colors[selectedIndex].brightTheme;
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
  /// Does nothing if [pair] with equal colours is already in [colors]
  void addColorPair(ColorPair pair) {
    if (colors.none(
      (p0) => p0 == pair,
    )) {
      colors.add(pair.copy());
    }
  }

  /// Removes a [ColorPair] at index [i]
  ///
  /// Returns the removed pair
  /// Returns null if [i] is out of range for [colors]
  ColorPair? removeColorPairAt(int i) {
    if (i < colors.length && i >= 0) {
      return colors.removeAt(i);
    } else {
      log(
        'Tried to remove out of index colour: Index $i, length: ${colors.length}',
        name: '$runtimeType.removeColorPairAt',
      );
      return null;
    }
  }

  void removeNonDefaultColors() {
    colors.clear();
    colors.add(ColorPair.defaultColors);
  }

  void removeAllColors() {
    colors.clear();
  }
}

class ColorSelectionRow extends StatefulWidget {
  final ColorSelectionController? controller;
  final double? height;

  const ColorSelectionRow({super.key, this.controller, this.height});

  @override
  State<ColorSelectionRow> createState() => _ColorSelectionRowState();
}

class _ColorSelectionRowState extends State<ColorSelectionRow> {
  late final ColorSelectionController controller;

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: [
        ...controller.colors.mapIndexed(
          (i, color) => Container(
            decoration: i == controller.selectedIndex
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [color.darkTheme, color.brightTheme],
                      begin: const FractionalOffset(-0.9, -0.9),
                      end: const FractionalOffset(0.9, 0.9),
                    ),
                  )
                : null,
            child: GestureDetector(
              onTap: () {
                setState(() => controller.selectedIndex = i);
              },
              onLongPress: () =>
                  setState(() => controller.removeColorPairAt(i)),
              child: Container(
                height: widget.height ?? 24,
                margin: const EdgeInsets.all(8),
                child: HalvedCircle(
                  topLeft: color.darkTheme,
                  bottomRight: color.brightTheme,
                ),
              ),
            ),
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
