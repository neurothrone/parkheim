import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

import '../../../core/routing/routing.dart';

class HistoryParkingListTile extends StatelessWidget {
  const HistoryParkingListTile({
    super.key,
    required this.parking,
  });

  final Parking parking;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => AppRouter.go(
        context,
        AppRoute.finishedParking,
        extra: parking,
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Hero(
                tag: parking.id,
                child: Icon(Icons.local_parking_rounded),
              ),
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
              Icon(Icons.attach_money_rounded),
              const SizedBox(width: 10.0),
              Text(
                "${parking.parkingCosts()}",
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
