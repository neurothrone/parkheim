import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/widgets/widgets.dart';
import '../../people/widgets/person_details.dart';
import '../state/vehicle_list_bloc.dart';
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

    if (!deleteConfirmed && !context.mounted) {
      return;
    }

    context.read<VehicleListBloc>().add(VehicleListDeleteItem(id: vehicle.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleListBloc, VehicleListState>(
      listener: (context, state) {
        if (state is VehicleListFailure) {
          SnackBarService.showError(context, "Error: ${state.message}");
        } else if (state is! VehicleListLoading) {
          Navigator.of(context).pop();
          SnackBarService.showSuccess(context, "Vehicle deleted");
        }
      },
      child: CustomScaffold(
        title: "Vehicle Details",
        actions: [
          BlocBuilder<VehicleListBloc, VehicleListState>(
            builder: (context, state) {
              return IconButton(
                onPressed: state is VehicleListLoading
                    ? null
                    : () async => await _deleteVehicle(context),
                tooltip: "Delete Vehicle",
                icon: Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                ),
              );
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: vehicle.id,
                child: CustomCircleAvatar(
                  icon: vehicle.vehicleType == VehicleType.car
                      ? Icons.directions_car_rounded
                      : Icons.motorcycle_rounded,
                ),
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
      ),
    );
  }
}
