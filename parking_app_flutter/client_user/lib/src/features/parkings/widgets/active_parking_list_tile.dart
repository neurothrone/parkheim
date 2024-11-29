import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../../../core/routing/routing.dart';

class ActiveParkingListTile extends StatelessWidget {
  const ActiveParkingListTile({
    super.key,
    required this.parking,
  });

  final Parking parking;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => AppRouter.go(
        context,
        AppRoute.activeParking,
        extra: parking,
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_parking_rounded),
              const SizedBox(width: 10.0),
              Text(
                parking.parkingSpace!.address,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.numbers_rounded),
              const SizedBox(width: 10.0),
              Text(
                parking.vehicle!.registrationNumber,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.schedule_rounded),
              const SizedBox(width: 10.0),
              Text(
                parking.startTime.formatted,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.black45,
      ),
    );
  }
}
