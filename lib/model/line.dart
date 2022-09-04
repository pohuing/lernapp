import 'dart:developer';

import 'package:flutter/material.dart';

class Line {
  List<Offset> path;

  Line(this.path);

  void prune() {
    var counter = 0;
    while (pruneOnce()) {
      counter++;
    }
    log('Used $counter passes', name: '$runtimeType.prune()');
  }

  bool pruneOnce() {
    if (path.length < 3) {
      return false;
    }
    final List<int> offsetsToRemove = [];
    for (var i = 0; i < path.length - 2; ++i) {
      final centerPoint = path[i + 1];
      final point1 = path[i];
      final point2 = path[i + 2];

      if (isPointOnLine(point1, point2, centerPoint)) {
        offsetsToRemove.add(i + 1);
      }
    }
    log('Pruned ${offsetsToRemove.length} out of ${path.length} offsets(${(offsetsToRemove.length / path.length) * 100}%)',
        name: '$runtimeType.pruneOnce()');
    for (var index in offsetsToRemove.reversed) {
      path.removeAt(index);
    }

    return offsetsToRemove.isNotEmpty;
  }

  bool isPointOnLine(Offset point1, Offset point2, Offset centerPoint) {
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

    return cross.abs() < 0.0001 &&
        isBetweenPoints(dxl, dyl, point1, centerPoint, point2);
  }

  bool isBetweenPoints(
      double dxl, double dyl, Offset point1, Offset currPoint, Offset point2) {
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

  void add(Offset point) {
    // TODO prune right here to avoid the performance hit while drawing.
    path.add(point);
  }
}
