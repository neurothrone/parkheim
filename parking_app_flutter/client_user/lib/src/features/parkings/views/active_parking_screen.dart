import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/routing/routing.dart';
import '../../../core/widgets/widgets.dart';
import '../../vehicles/widgets/vehicle_details.dart';
import '../state/active_parkings/active_parkings_bloc.dart';
import '../widgets/parking_space_details.dart';

class ActiveParkingScreen extends StatelessWidget {
  const ActiveParkingScreen({
    super.key,
    required this.parking,
  });

  final Parking parking;

  Future<void> _endParking(BuildContext context) async {
    final result = await RemoteParkingRepository.instance.endParking(parking);
    result.when(
      success: (Parking parking) {
        context.read<ActiveParkingsBloc>().add(ActiveParkingUpdate());
        AppRouter.pop(context);
        SnackBarService.showSuccess(context, "Parking ended successfully");
      },
      failure: (error) {
        SnackBarService.showError(context, "Failed to end parking");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Parking",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Hero(
              tag: parking.id,
              child: CustomCircleAvatar(icon: Icons.local_parking_rounded),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Started parking:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  parking.startTime.formatted,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Divider(),
            const SizedBox(height: 10.0),
            if (parking.parkingSpace != null) ...[
              ParkingSpaceDetails(space: parking.parkingSpace!),
              Divider(),
              const SizedBox(height: 10.0),
            ],
            if (parking.vehicle != null) ...[
              VehicleDetails(vehicle: parking.vehicle!),
              Divider(),
              const SizedBox(height: 20.0),
            ],
            CustomFilledButton(
              onPressed: () async => await _endParking(context),
              text: "End Parking",
            ),
          ],
        ),
      ),
    );
  }
}
