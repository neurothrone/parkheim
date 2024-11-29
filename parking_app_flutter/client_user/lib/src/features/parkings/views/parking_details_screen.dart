import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/widgets/widgets.dart';
import '../widgets/parking_space_details.dart';

class ParkingDetailsScreen extends StatelessWidget {
  const ParkingDetailsScreen({
    super.key,
    required this.parkingSpace,
  });

  final ParkingSpace parkingSpace;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Parking",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomCircleAvatar(icon: Icons.local_parking_rounded),
            const SizedBox(height: 20.0),
            ParkingSpaceDetails(parkingSpace: parkingSpace),
            AddParkingForm(parkingSpace: parkingSpace),
          ],
        ),
      ),
    );
  }
}

class AddParkingForm extends StatefulWidget {
  const AddParkingForm({
    super.key,
    required this.parkingSpace,
  });

  final ParkingSpace parkingSpace;

  @override
  State<AddParkingForm> createState() => _AddParkingFormState();
}

class _AddParkingFormState extends State<AddParkingForm> {
  final _formKey = GlobalKey<FormState>();

  int _vehicleId = -1;
  List<Vehicle> _vehicles = [];
  Vehicle? _vehicle;

  final RemoteVehicleRepository _vehicleRepository =
      RemoteVehicleRepository.instance;
  final RemoteParkingRepository _parkingRepository =
      RemoteParkingRepository.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // TODO: get all vehicles for the user
      final result = await _vehicleRepository.getAll();
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
    });
  }

  Future<void> _onFormSubmitted() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await _parkingRepository.create(
      Parking(
        id: 0,
        vehicle: _vehicle,
        parkingSpace: widget.parkingSpace,
        startTime: DateTime.now(),
        endTime: null,
      ),
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
