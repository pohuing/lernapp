import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  void onTapDate(BuildContext context) async {
    final result = await showDatePicker(
      context: context,
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

  void onTapTime(BuildContext context) async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value),
    );
    if (result is TimeOfDay) {
      onChange?.call(value.copyWith(hour: result.hour, minute: result.minute));
    }
  }
}
