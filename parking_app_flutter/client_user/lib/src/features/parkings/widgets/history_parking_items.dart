import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import 'history_parking_list_tile.dart';

class HistoryParkingItems extends StatelessWidget {
  const HistoryParkingItems({super.key});

  Future<List<Parking>> _findFinishedParkings() async {
    final vehicleResult = await RemoteVehicleRepository.instance.getAll();
    final vehicle = vehicleResult.when(
      success: (List<Vehicle> vehicles) {
        return vehicles.first;
      },
      failure: (error) {
        return null;
      },
    );

    if (vehicle == null) {
      return [];
    }

    final parkingResults = await RemoteParkingRepository.instance
        .findFinishedParkingsForVehicle(vehicle);
    return parkingResults.when(
      success: (List<Parking> parkings) {
        return parkings;
      },
      failure: (error) {
        return [];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: get current user and find parkings for that user
    // final vehicleResult = await RemoteVehicleRepository.instance.findVehicleByUser
    // (AppUserCubit.instance.state.user!);

    return FutureBuilder<List<Parking>>(
      future: _findFinishedParkings(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final parkings = snapshot.data!;
          if (parkings.isEmpty) {
            return Center(
              child: Text("No parking spaces available."),
            );
          }

          return ListView.separated(
            itemCount: parkings.length,
            itemBuilder: (context, index) {
              final parking = parkings[index];
              return HistoryParkingListTile(parking: parking);
            },
            separatorBuilder: (context, index) => const Divider(height: 0),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
