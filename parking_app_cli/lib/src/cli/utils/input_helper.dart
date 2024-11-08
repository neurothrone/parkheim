import 'dart:io';

class InputHelper {
  InputHelper._internal();

  static String? geStringInput(
    String name, {
    String? message,
    bool canBeEmpty = false,
  }) {
    while (true) {
      if (message != null) {
        stdout.writeln(message);
      } else {
        stdout.write("Enter $name: ");
      }

      String input = stdin.readLineSync() ?? "";
      if (input == "0") {
        return null;
      }

      if (canBeEmpty) {
        return input;
      }

      if (input.isNotEmpty) {
        return input;
      }

      stdout.writeln("$name can not be empty.");
    }
  }

  static double? getDoubleInput(
    String name, {
    String? message,
    bool allowNegative = false,
  }) {
    while (true) {
      if (message != null) {
        stdout.writeln(message);
      } else {
        stdout.write("Enter $name: ");
      }

      String input = stdin.readLineSync() ?? "";
      if (input == "0") {
        return null;
      }

      double? value = double.tryParse(input);
      if (value == null) {
        stdout.writeln("Invalid input. Try entering a number.");
        continue;
      }

      if (!allowNegative && value < 0) {
        stdout.writeln("$name can not be negative.");
        continue;
      }

      return value;
    }
  }

  static DateTime? getCustomDateTimeInput(
    String name, {
    DateTime? start,
    DateTime? end,
  }) {
    stdout.writeln("Enter $name in the format '2024-10-06 13:30:00'");

    while (true) {
      final input = stdin.readLineSync() ?? "";
      if (input == "0") {
        return null;
      }

      DateTime dateTime;
      try {
        dateTime = DateTime.parse(input);
      } on FormatException {
        stdout.writeln("Invalid format, try again.");
        continue;
      }

      if (start != null && dateTime.isBefore(start)) {
        stdout.writeln("The datetime can not be before $start.");
        continue;
      }

      if (end != null && dateTime.isAfter(end)) {
        stdout.writeln("The datetime can not be after $end.");
        continue;
      }

      return dateTime;
    }
  }
}
