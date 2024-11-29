import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/routing/routing.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/vehicle_list.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

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
      child: VehiclesScreenContent(),
    );
  }
}

class VehiclesScreenContent extends StatelessWidget {
  const VehiclesScreenContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<List<Vehicle>, String>>(
      future: RemoteVehicleRepository.instance.getAll(),
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
    );
  }
}
