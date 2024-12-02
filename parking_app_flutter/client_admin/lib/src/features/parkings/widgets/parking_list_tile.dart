import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class ParkingListTile extends StatelessWidget {
  const ParkingListTile({
    super.key,
    required this.parking,
  });

  final Parking parking;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Address:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                parking.parkingSpace?.address ?? "Unknown",
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
                "Started:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                parking.startTime.formatted,
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
                "Ended:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                parking.endTime?.formatted ?? "Ongoing",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
