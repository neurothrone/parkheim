import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

import '../../../core/routing/routing.dart';

class VehicleListTile extends StatelessWidget {
  const VehicleListTile({
    super.key,
    required this.vehicle,
  });

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => AppRouter.go(
        context,
        AppRoute.vehicleDetails,
        extra: vehicle,
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(vehicle.vehicleType == VehicleType.car
              ? Icons.directions_car_rounded
              : Icons.motorcycle_rounded),
          Icon(Icons.numbers_rounded),
        ],
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(vehicle.vehicleType.name.capitalized),
          Text(vehicle.registrationNumber),
        ],
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.black45,
      ),
    );
  }
}
