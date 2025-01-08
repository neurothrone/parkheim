import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../vehicles/state/vehicle_list_bloc.dart';
import '../state/available_spaces/available_spaces_bloc.dart';

class AddParkingForm extends StatefulWidget {
  const AddParkingForm({
    super.key,
    required this.space,
  });

  final ParkingSpace space;

  @override
  State<AddParkingForm> createState() => _AddParkingFormState();
}

class _AddParkingFormState extends State<AddParkingForm> {
  final _formKey = GlobalKey<FormState>();

  int _vehicleId = -1;
  List<Vehicle> _vehicles = [];
  Vehicle? _vehicle;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadVehicles();
    });
  }

  Future<void> _loadVehicles() async {
    final result = await context.read<VehicleListBloc>().getVehiclesForOwner();
    result.when(
      success: (vehicles) {
        _vehicles = vehicles;
        _vehicleId = _vehicles.first.id;
        _vehicle = _vehicles.first;
        setState(() {});
      },
      failure: (error) {
        SnackBarService.showError(context, "Error: $error");
      },
    );
  }

  Future<void> _onFormSubmitted() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await context.read<AvailableSpacesBloc>().startParking(
          space: widget.space,
          vehicle: _vehicle!,
        );

    result.when(
      success: (_) {
        Navigator.of(context).pop();
        SnackBarService.showSuccess(context, "Parking started");
      },
      failure: (error) => SnackBarService.showError(context, "Error: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<int>(
            onChanged: (int? newValue) {
              setState(() => _vehicleId = newValue!);
            },
            validator: (int? value) {
              if (value == null || value == -1) {
                return "Vehicle is required";
              }
              return null;
            },
            value: _vehicleId,
            decoration: InputDecoration(labelText: "Vehicle"),
            items: _vehicles.map<DropdownMenuItem<int>>((Vehicle vehicle) {
              return DropdownMenuItem<int>(
                onTap: () => _vehicle = vehicle,
                value: vehicle.id,
                child: Text(vehicle.registrationNumber),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          CustomFilledButton(
            onPressed: _onFormSubmitted,
            text: "Start Parking",
          ),
        ],
      ),
    );
  }
}
