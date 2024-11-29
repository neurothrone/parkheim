import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import 'active_parking_list_tile.dart';

class ActiveParkingItems extends StatelessWidget {
  const ActiveParkingItems({super.key});

  Future<List<Parking>> _getActiveParkings() async {
    final vehicleResult = await RemoteVehicleRepository.instance.getAll();
    return vehicleResult.when(
      success: (List<Vehicle> vehicles) async {
        if (vehicles.isEmpty) {
          return [];
        }
        return await RemoteParkingRepository.instance
            .findActiveParkingsByVehicle(vehicles.first);
      },
      failure: (error) => [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Parking>>(
      future: _getActiveParkings(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final parkings = snapshot.data!;
          if (parkings.isEmpty) {
            return Center(
              child: Text("No active parkings available."),
            );
          }

          return ListView.separated(
            itemCount: parkings.length,
            itemBuilder: (context, index) {
              final parking = parkings[index];
              return ActiveParkingListTile(parking: parking);
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

