import 'dart:io';

import 'package:shared/shared.dart';
import '../ui/constants.dart';

extension VehicleTypeExtensions on VehicleType {
  static void listOneBasedIndexedValues({bool excludeUnknown = true}) {
    stdout.writeln(Constants.divider);
    stdout.writeln("Vehicle Types");
    stdout.writeln(Constants.divider);
    final vehicleTypes = VehicleType.values;
    for (int i = 0; i < vehicleTypes.length; i++) {
      if (vehicleTypes[i] == VehicleType.unknown && excludeUnknown) {
        continue;
      }

      stdout.writeln("${i + 1} - ${vehicleTypes[i].name.capitalized}");
    }
    stdout.writeln(Constants.divider);
  }
}
