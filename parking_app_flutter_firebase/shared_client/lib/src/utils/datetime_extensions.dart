import 'package:intl/intl.dart';

extension DatetimeExtensions on DateTime {
  String get formatted {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final yesterday = today.subtract(Duration(days: 1));

    if (isAfter(today) && isBefore(tomorrow)) {
      return "Today, ${DateFormat("HH:mm").format(this)}";
    } else if (isAfter(yesterday) && isBefore(today)) {
      return "Yesterday, ${DateFormat("HH:mm").format(this)}";
    } else if (year == now.year) {
      return DateFormat("MMM dd, HH:mm").format(this);
    } else {
      return DateFormat("yyyy MMM dd, HH:mm").format(this);
    }
  }
}
