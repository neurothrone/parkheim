import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../core/cubits/app_user/app_user_state.dart';
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

  Future<List<Vehicle>> _getVehicles(BuildContext context) async {
    final appUserCubit = context.read<AppUserCubit>();
    final user = (appUserCubit.state as AppUserSignedIn).user;

    final ownerResult = await RemotePersonRepository.instance
        .findPersonByName(user.displayName!);
    final owner = ownerResult.when(
      success: (person) => person,
      failure: (error) {
        SnackBarService.showError(context, "Error: Owner not found");
        return null;
      },
    );
    if (owner == null) {
      return [];
    }

    final vehicleResults =
        await RemoteVehicleRepository.instance.findVehiclesByOwner(owner);
    return vehicleResults.when(
      success: (vehicles) => vehicles,
      failure: (_) => [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Vehicle>>(
      future: _getVehicles(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final vehicles = snapshot.data!;
          if (vehicles.isEmpty) {
            return Center(
              child: Text("No vehicles registered."),
            );
          }

          return VehicleList(vehicles: vehicles);
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
