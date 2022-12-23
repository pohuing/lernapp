import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/logic/list_extensions.dart';
import 'package:lernapp/logic/logging.dart';
import 'package:lernapp/logic/offset_extensions.dart';
import 'package:lernapp/model/color_pair.dart';
import 'package:lernapp/model/pair.dart';
import 'package:system_theme/system_theme.dart';

/// A line made up of a series of points and a [ColorPair] and a thickness
class Line {
  final List<Offset> path;
  final ColorPair colors;
  final double size;

  var _savedCounter = 0;

  static const colorsKey = 'colors';
  static const String sizeKey = 'size';
  static const pathKey = 'path';

  Line(this.path, this.colors, this.size);

  Line.withDefaultProperties(this.path)
      : colors = const ColorPair.defaultColors().copy(),
        size = 1;

  @override
  int get hashCode => path.fold(
        colors.hashCode,
        (previousValue, element) => previousValue ^ element.hashCode,
      );

  /// Adaptive color based on system theme for good contrast
  Color get paintColor =>
      SystemTheme.isDarkMode ? colors.darkTheme : colors.brightTheme;

  Iterable<Pair<Offset>> get windowed sync* {
    if (path.length == 1) {
      yield Pair(path[0], path[0]);
      return;
    }
    for (int i = 0; i < path.length - 1; i++) {
      yield Pair(path[i], path[i + 1]);
    }
    return;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Line &&
          runtimeType == other.runtimeType &&
          path.equals(other.path) &&
          colors == other.colors;

  /// Adds a point to this line
  ///
  /// This removes the last point if it lies on a point between the second to
  /// last and the new point
  void add(Offset point) {
    if (path.length >= 2 &&
        isPointOnLine(
          point1: path[path.length - 2],
          point2: point,
          centerPoint: path.last,
        )) {
      path.last = point;
      _savedCounter++;
      if (kDebugMode) {
        log(
          'Avoided adding redundant point. Saved $_savedCounter points',
          name: 'Line.add()',
        );
      }
    } else {
      path.add(point);
    }
  }

  /// Test if this Line is within a circle
  ///
  /// This includes touching
  /// [center]: is the center of the circle
  /// [radius]: is the center of the radius
  bool isInCircle(Offset center, double radius) {
    if (path.length == 1) {
      return (path.first - center).distance <= radius + size;
    }
    for (int i = 0; i < path.length - 1; i++) {
      if (segmentInCircle(path[i], path[i + 1], center, radius, size)) {
        return true;
      }
    }
    return false;
  }

  /// Remove all redundant points from this line
  ///
  /// Redundant points are point that are almost exactly on the line drawn from
  /// their neighbor points
  bool prune() {
    if (path.length < 3) {
      return false;
    }
    final List<int> offsetsToRemove = [];
    for (var i = 0; i < path.length - 2; ++i) {
      final centerPoint = path[i + 1];
      final point1 = path[i];
      final point2 = path[i + 2];

      if (isPointOnLine(
        point1: point1,
        point2: point2,
        centerPoint: centerPoint,
      )) {
        offsetsToRemove.add(i + 1);
      }
    }
    if (kDebugMode) {
      log(
        'Pruned ${offsetsToRemove.length} out of ${path.length} offsets(${(offsetsToRemove.length / path.length) * 100}%)',
        name: 'Line.prune()',
      );
    }
    for (var index in offsetsToRemove.reversed) {
      path.removeAt(index);
    }
    if (kDebugMode) {
      log('Pruned points $offsetsToRemove', name: 'Line.prune()');
    }
    return offsetsToRemove.isNotEmpty;
  }

  /// Calculate the distance of point p from the finite line drawn between a and b
  static double distanceLinePoint(Offset p1, Offset p2, Offset point) {
    final pDash = point - p1;
    final p2Dash = (p2 - p1).normalised();
    final dot = pDash.dot(p2Dash);
    if (dot < 0) {
      return pDash.distance;
    } else if (dot > (p2 - p1).distance) {
      return (point - p2).distance;
    } else {
      var dot = pDash.dot(p2Dash);
      var scalarMul = p2Dash.scalarMul(dot) + p1;
      var offset = point - scalarMul;
      var distance2 = (offset).distance;
      return distance2;
    }
  }

  /// Test if center is on a line drawn from [point1] to [point2]
  static bool isPointOnLine({
    required Offset point1,
    required Offset point2,
    required Offset centerPoint,
    double error = 0.01,
  }) {
    if (point1 == point2) {
      if (point1 == centerPoint) {
        return true;
      }
      return false;
    }

    final dxc = centerPoint.dx - point1.dx;
    final dyc = centerPoint.dy - point1.dy;

    final dxl = point2.dx - point1.dx;
    final dyl = point2.dy - point1.dy;

    final cross = dxc * dyl - dyc * dxl;

    return cross.abs() < error &&
        _isBetweenPoints(dxl, dyl, point1, centerPoint, point2);
  }

  /// Test if finite line is in a circle
  static bool segmentInCircle(
    Offset p1,
    Offset p2,
    Offset center,
    double radius,
    double lineWidth,
  ) {
    return distanceLinePoint(p1, p2, center) <= radius + lineWidth / 2;
  }

  static bool _isBetweenPoints(
    double dxl,
    double dyl,
    Offset point1,
    Offset currPoint,
    Offset point2,
  ) {
    if (dxl.abs() >= dyl.abs()) {
      return dxl > 0
          ? point1.dx <= currPoint.dx && currPoint.dx <= point2.dx
          : point2.dx <= currPoint.dx && currPoint.dx <= point1.dx;
    } else {
      return dyl > 0
          ? point1.dy <= currPoint.dy && currPoint.dy <= point2.dy
          : point2.dy <= currPoint.dy && currPoint.dy <= point1.dy;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      sizeKey: size,
      colorsKey: colors.toMap(),
      pathKey: path.map((e) => [e.dx, e.dy]).flattened.toList(),
    };
  }

  static Line? fromMap(Map map) {
    try {
      final size = (map[sizeKey] as num).toDouble();
      final colors = ColorPair.fromMap(map[colorsKey])!;
      final offsets = List<double>.from(map[pathKey]);
      assert(offsets.length % 2 == 0);
      final path = offsets.pairwise().map((e) => Offset(e.one, e.two)).toList();
      return Line(
        path,
        colors,
        size,
      );
    } catch (e) {
      log(
        'Failed to create Line, error ${e.toString()}',
        name: 'Line.fromMap()',
      );
    }
    return null;
  }
}
