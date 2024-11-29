import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/routing/routing.dart';

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
