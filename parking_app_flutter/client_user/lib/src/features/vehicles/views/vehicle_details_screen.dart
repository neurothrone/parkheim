import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/routing/routing.dart';
import '../../../core/widgets/widgets.dart';
import '../../people/widgets/person_details.dart';
import '../widgets/vehicle_details.dart';

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({
    super.key,
    required this.vehicle,
  });

  final Vehicle vehicle;

  Future<void> _deleteVehicle(BuildContext context) async {
    final deleteConfirmed = await showConfirmDialog(
      context,
      "Are you sure you want to delete this vehicle?",
    );

    if (!deleteConfirmed) {
      return;
    }

    final result = await RemoteVehicleRepository.instance.delete(vehicle.id);
    result.when(
      success: (_) {
        AppRouter.pop(context);
        SnackBarService.showSuccess(context, "Vehicle Deleted");
      },
      failure: (error) {
        SnackBarService.showError(context, "Error: $error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Vehicle Details",
      actions: [
        IconButton(
          onPressed: () async => await _deleteVehicle(context),
          tooltip: "Delete Vehicle",
          icon: Icon(
            Icons.delete_rounded,
            color: Colors.red,
          ),
        ),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomCircleAvatar(
              icon: vehicle.vehicleType == VehicleType.car
                  ? Icons.directions_car_rounded
                  : Icons.motorcycle_rounded,
            ),
            const SizedBox(height: 10.0),
            VehicleDetails(vehicle: vehicle),
            if (vehicle.owner != null) ...[
              const SizedBox(height: 10.0),
              Divider(),
              const SizedBox(height: 10.0),
              Text(
                "Registered owner",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 10.0),
              PersonDetails(person: vehicle.owner!),
            ],
          ],
        ),
      ),
    );
  }
}
