import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../../../core/routing/routing.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/vehicle_list.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final RemoteVehicleRepository _vehicleRepository =
      RemoteVehicleRepository.instance;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Vehicles",
      actions: [
        IconButton(
          onPressed: () => AppRouter.go(context, AppRoute.addVehicle),
          tooltip: "Register Vehicle",
          icon: Icon(Icons.add_rounded),
        ),
      ],
      bottomNavigationBar: CustomNavigationBar(),
      child: FutureBuilder<Result<List<Vehicle>, String>>(
        future: _vehicleRepository.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final result = snapshot.data!;
            return result.when(
              success: (List<Vehicle> v) => VehicleList(vehicles: v),
              failure: (error) => Center(child: Text("Error: $error")),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return CenteredProgressIndicator();
        },
      ),
    );
  }
}
