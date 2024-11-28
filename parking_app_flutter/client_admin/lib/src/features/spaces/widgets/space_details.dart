import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

class SpaceDetails extends StatelessWidget {
  const SpaceDetails({
    super.key,
    required this.space,
  });

  final ParkingSpace space;

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
              space.address,
              style: Theme.of(context).textTheme.bodyLarge,
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
              space.pricePerHour.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
