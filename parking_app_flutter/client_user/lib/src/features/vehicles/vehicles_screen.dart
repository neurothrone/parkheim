import 'package:flutter/material.dart';

import '../../core/widgets/widgets.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Vehicles",
      bottomNavigationBar: CustomNavigationBar(),
      child: Center(
        child: Text("Vehicles"),
      ),
    );
  }
}
