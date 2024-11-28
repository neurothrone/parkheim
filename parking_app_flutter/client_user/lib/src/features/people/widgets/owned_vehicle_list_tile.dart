import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

class OwnedVehicleListTile extends StatelessWidget {
  const OwnedVehicleListTile({
    super.key,
    required this.vehicle,
  });

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      horizontalTitleGap: 10.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Vehicle type:",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            vehicle.vehicleType.name.capitalized,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Registration number:",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            vehicle.registrationNumber,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
