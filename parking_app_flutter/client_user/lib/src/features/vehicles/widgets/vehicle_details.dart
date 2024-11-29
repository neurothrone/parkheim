import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

class VehicleDetails extends StatelessWidget {
  const VehicleDetails({
    super.key,
    required this.vehicle,
  });

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Vehicle type:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              vehicle.vehicleType.name.capitalized,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Registration number:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              vehicle.registrationNumber,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
