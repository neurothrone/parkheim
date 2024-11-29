import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

import '../../../core/routing/routing.dart';

class AllParkingListTile extends StatelessWidget {
  const AllParkingListTile({
    super.key,
    required this.space,
  });

  final ParkingSpace space;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => AppRouter.go(
        context,
        AppRoute.parkingDetails,
        extra: space,
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
                space.address,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.attach_money_rounded),
              const SizedBox(width: 10.0),
              Text(
                space.pricePerHour.toString(),
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
