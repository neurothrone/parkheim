import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../core/cubits/app_user/app_user_state.dart';
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

  final RemoteVehicleRepository _vehicleRepository =
      RemoteVehicleRepository.instance;
  final RemoteParkingRepository _parkingRepository =
      RemoteParkingRepository.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadVehicles();
    });
  }

  Future<void> _loadVehicles() async {
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
      return;
    }

    final result = await _vehicleRepository.findVehiclesByOwner(owner);
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

    final result = await _parkingRepository.create(
      Parking(
        id: 0,
        vehicle: _vehicle,
        parkingSpace: widget.space,
        startTime: DateTime.now(),
        endTime: null,
      ),
    );
    result.when(
      success: (_) {
        context.read<AvailableSpacesBloc>().add(AllParkingUpdate());
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
