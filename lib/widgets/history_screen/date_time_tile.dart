import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A Row for picking a time and date, using the platform native pickers.
/// The tile does not store any state itself, instead update the [value] through
/// [onChange].
class DateTimeTile extends StatelessWidget {
  const DateTimeTile({
    super.key,
    this.title,
    required this.value,
    this.onChange,
    this.leading,
  });

  final String? title;
  final DateTime value;
  final Widget? leading;
  final Function(DateTime newDateTime)? onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          if (leading != null) leading!,
          if (leading != null) const SizedBox(width: 28),
          if (title != null)
            Text(title!, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          InkWell(
            onTap: onChange != null ? () => onTapDate(context) : null,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(DateFormat(DateFormat.YEAR_MONTH_DAY).format(value)),
            ),
          ),
          InkWell(
            onTap: onChange != null ? () => onTapTime(context) : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(DateFormat(DateFormat.HOUR24_MINUTE).format(value)),
            ),
          ),
        ],
      ),
    );
  }

  void iOSTap(BuildContext context) async {
    DateTime? newTime;
    await showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (context) => SizedBox(
        height: 216,
        child: CupertinoDatePicker(
          use24hFormat: true,
          mode: CupertinoDatePickerMode.dateAndTime,
          initialDateTime: value,
          onDateTimeChanged: (value) => newTime = value,
        ),
      ),
    );

    if (newTime != null) {
      onChange?.call(newTime!);
    }
  }

  void onTapDate(BuildContext context) async {
    if (!kIsWeb && (Platform.isIOS)) {
      iOSTap(context);
    } else {
      final result = await showDatePicker(
        context: context,
        helpText: title,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now(),
      );
      if (result is DateTime) {
        onChange?.call(
          value.copyWith(
            year: result.year,
            month: result.month,
            day: result.day,
          ),
        );
      }
    }
  }

  void onTapTime(BuildContext context) async {
    if (!kIsWeb && (Platform.isIOS)) {
      iOSTap(context);
    } else {
      final result = await showTimePicker(
        context: context,
        helpText: title,
        initialTime: TimeOfDay.fromDateTime(value),
      );
      if (result is TimeOfDay) {
        onChange
            ?.call(value.copyWith(hour: result.hour, minute: result.minute));
      }
    }
  }
}
