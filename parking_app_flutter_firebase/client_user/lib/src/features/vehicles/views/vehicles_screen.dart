import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/routing/routing.dart';
import '../../../core/widgets/widgets.dart';
import '../state/vehicle_list_bloc.dart';
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
      child: OwnedVehiclesList(),
    );
  }
}

class OwnedVehiclesList extends StatelessWidget {
  const OwnedVehiclesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleListBloc, VehicleListState>(
      builder: (context, state) {
        if (state is VehicleListEmpty) {
          return Center(
            child: Text("No vehicles available."),
          );
        } else if (state is VehicleListLoaded) {
          final vehicles = state.vehicles;
          return VehicleList(vehicles: vehicles);
        } else if (state is VehicleListFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
