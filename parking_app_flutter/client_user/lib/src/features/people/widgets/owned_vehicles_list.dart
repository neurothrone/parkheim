import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

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
    return FutureBuilder<Result<List<Vehicle>, String>>(
      future: _vehicleRepository.findVehiclesByOwner(widget.owner),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data!;
          return result.when(
            success: (vehicles) {
              if (vehicles.isEmpty) {
                return SizedBox.shrink();
              }

              return VehicleList(
                vehicles: vehicles,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                listType: VehicleListType.owned,
              );
            },
            failure: (error) => Center(
              child: Text("Error: ${snapshot.error}"),
            ),
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
