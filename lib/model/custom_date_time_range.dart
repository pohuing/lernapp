import 'package:flutter/material.dart';

class CustomDateTimeRange {
  final DateTime start;
  final DateTime end;

  const CustomDateTimeRange(this.start, this.end);

  static CustomDateTimeRange fromRange(DateTimeRange range) {
    // [DateTimeRange] expresses a whole day by having two identical DateTimes for start and end
    if (range.start.compareTo(range.end) == 0) {
      return CustomDateTimeRange(
        range.start.copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        ),
        range.end.copyWith(
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
        ),
      );
    } else {
      return CustomDateTimeRange(range.start.copyWith(), range.end.copyWith());
    }
  }

  CustomDateTimeRange sorted() {
    if (start.isAfter(end)) {
      return CustomDateTimeRange(end, start);
    } else {
      return CustomDateTimeRange(start, end);
    }
  }

  DateTimeRangeComparisonResult timeIn(DateTime date) {
    if (start.isBefore(date)) {
      if (end.isAfter(date)) {
        return DateTimeRangeComparisonResult.within;
      } else {
        return DateTimeRangeComparisonResult.before;
      }
    }
    return DateTimeRangeComparisonResult.after;
  }

  CustomDateTimeRange copyWith({DateTime? start, DateTime? end}) {
    return CustomDateTimeRange(start ?? this.start, end ?? this.end);
  }
}

enum DateTimeRangeComparisonResult {
  before,
  within,
  after,
}
