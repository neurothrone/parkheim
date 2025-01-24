import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import '../widgets/add_vehicle_form.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Add Vehicle",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: AddVehicleForm(),
      ),
    );
  }
}
