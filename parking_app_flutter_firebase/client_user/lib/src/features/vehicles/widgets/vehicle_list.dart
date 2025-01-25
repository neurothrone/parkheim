import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

import 'owned_vehicle_list_tile.dart';
import 'vehicle_list_tile.dart';

enum VehicleListType {
  all,
  owned,
}

class VehicleList extends StatelessWidget {
  const VehicleList({
    super.key,
    required this.vehicles,
    this.physics,
    this.shrinkWrap = false,
    this.listType = VehicleListType.all,
  });

  final List<Vehicle> vehicles;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final VehicleListType listType;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: physics,
      shrinkWrap: true,
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        return listType == VehicleListType.owned
            ? OwnedVehicleListTile(vehicle: vehicles[index])
            : VehicleListTile(vehicle: vehicles[index]);
      },
      separatorBuilder: (_, __) => Divider(height: 0),
    );
  }
}
