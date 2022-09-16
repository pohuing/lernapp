import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/logic/offset_extensions.dart';
import 'package:system_theme/system_theme.dart';

class Line {
  List<Offset> path;
  final Paint _paint;

  var _savedCounter = 0;

  Line(this.path, Paint? paint) : _paint = paint ?? Paint();

  @override
  int get hashCode => path.fold(
        _paint.hashCode,
        (previousValue, element) => previousValue ^ element.hashCode,
      );

  Paint get paint {
    return _paint
      ..color = paintColor
      ..isAntiAlias = true;
  }

  Color get paintColor => SystemTheme.isDarkMode ? Colors.white : Colors.black;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Line &&
          runtimeType == other.runtimeType &&
          path.equals(other.path) &&
          _paint == other._paint;

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

  bool isBetweenPoints(
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

  bool isInCircle(Offset center, double radius) {
    for (int i = 0; i < path.length - 1; i++) {
      if (segmentInCircle(path[i], path[i + 1], center, radius)) {
        return true;
      }
    }
    return false;
  }

  static double distanceLinePoint(Offset a, Offset b, Offset p) {
    final pDash = p - a;
    final bDash = (b - a).normalised();
    final dot = pDash.dot(bDash);
    if (dot < 0) {
      return pDash.distance;
    } else if (dot > (b - a).distance) {
      return (p - b).distance;
    } else {
      return (pDash - bDash.scalarMul(pDash.dot(bDash))).distance;
    }
  }

  static bool segmentInCircle(
      Offset p1, Offset p2, Offset center, double radius) {
    return distanceLinePoint(p1, p2, center) <= radius;
  }

  bool isPointOnLine({
    required Offset point1,
    required Offset point2,
    required Offset centerPoint,
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

    return cross.abs() < 0.01 &&
        isBetweenPoints(dxl, dyl, point1, centerPoint, point2);
  }

  bool prune() {
    if (path.length < 3) {
      return false;
    }
    final List<int> offsetsToRemove = [];
    // Clean up with retain where
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
}
