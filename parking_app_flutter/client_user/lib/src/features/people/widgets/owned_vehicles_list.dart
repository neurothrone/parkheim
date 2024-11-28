import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../../../core/widgets/widgets.dart';
import '../../vehicles/widgets/vehicle_list.dart';

class OwnedVehiclesList extends StatefulWidget {
  const OwnedVehiclesList({
    super.key,
    required this.owner,
  });

  final Person owner;

  @override
  State<OwnedVehiclesList> createState() => _OwnedVehiclesListState();
}

class _OwnedVehiclesListState extends State<OwnedVehiclesList> {
  final RemoteVehicleRepository _vehicleRepository =
      RemoteVehicleRepository.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Vehicle>>(
      future: _vehicleRepository.findVehiclesByOwner(widget.owner),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final vehicles = snapshot.data!;
          return VehicleList(
            vehicles: vehicles,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            listType: VehicleListType.owned,
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
