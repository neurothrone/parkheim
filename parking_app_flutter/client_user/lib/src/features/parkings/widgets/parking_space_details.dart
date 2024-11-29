import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

class ParkingSpaceDetails extends StatelessWidget {
  const ParkingSpaceDetails({
    super.key,
    required this.parkingSpace,
  });

  final ParkingSpace parkingSpace;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Address:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              parkingSpace.address,
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
              "Price per hour:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "\$${parkingSpace.pricePerHour}",
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
