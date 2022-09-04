import 'dart:developer';

import 'package:flutter/material.dart';

class Line {
  List<Offset> path;

  var _savedCounter = 0;

  Line(this.path);

  void add(Offset point) {
    if (path.length >= 2 &&
        isPointOnLine(
          point1: path[path.length - 2],
          point2: point,
          centerPoint: path.last,
        )) {
      path.last = point;
      _savedCounter++;
      log(
        'Avoided adding redundant point. Saved $_savedCounter points',
        name: 'Line.add()',
      );
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
    log(
      'Pruned ${offsetsToRemove.length} out of ${path.length} offsets(${(offsetsToRemove.length / path.length) * 100}%)',
      name: 'Line.prune()',
    );
    for (var index in offsetsToRemove.reversed) {
      path.removeAt(index);
    }
    log('Pruned points $offsetsToRemove', name: 'Line.prune()');
    return offsetsToRemove.isNotEmpty;
  }
}
