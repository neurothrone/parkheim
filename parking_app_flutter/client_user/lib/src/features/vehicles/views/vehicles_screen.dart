import 'package:flutter/material.dart';

import '../../core/routing/routing.dart';
import '../../core/widgets/widgets.dart';

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
      child: Center(
        child: Text("Vehicles"),
      ),
    );
  }
}
