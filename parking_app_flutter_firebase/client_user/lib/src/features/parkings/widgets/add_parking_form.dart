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

  Vehicle? _vehicle;

  @override
  void initState() {
    super.initState();
    context.read<VehicleListBloc>().add(VehicleListLoad());
  }

  Future<void> _onFormSubmitted() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_vehicle == null) {
      return;
    }

    context.read<AvailableSpacesBloc>().add(
          AvailableSpacesStartParking(
            space: widget.space,
            vehicle: _vehicle!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AvailableSpacesBloc, AvailableSpacesState>(
      listener: (context, state) {
        if (state is AvailableSpacesFailure) {
          SnackBarService.showError(context, "Error: ${state.message}");
        } else if (state is! AvailableSpacesLoading) {
          Navigator.of(context).pop();
          SnackBarService.showSuccess(context, "Parking started");
        }
      },
      child: Form(
        key: _formKey,
        child: BlocBuilder<VehicleListBloc, VehicleListState>(
          builder: (context, state) {
            if (state is VehicleListEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Text(
                    "No vehicles available. Please add a vehicle first.",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (state is VehicleListLoaded) {
              _vehicle ??= state.vehicles.first;

              return Column(
                children: [
                  VehicleDropDownForm(
                    vehicles: state.vehicles,
                    initialSelection: _vehicle!,
                    onVehicleSelected: (Vehicle vehicle) {
                      setState(() => _vehicle = vehicle);
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomFilledButton(
                    onPressed: _vehicle != null ? _onFormSubmitted : null,
                    text: "Start Parking",
                  ),
                ],
              );
            }

            if (state is VehicleListFailure) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return const CenteredProgressIndicator();
          },
        ),
      ),
    );
  }
}

class VehicleDropDownForm extends StatefulWidget {
  const VehicleDropDownForm({
    super.key,
    required this.vehicles,
    required this.initialSelection,
    required this.onVehicleSelected,
  });

  final List<Vehicle> vehicles;
  final Vehicle initialSelection;
  final Function(Vehicle vehicle) onVehicleSelected;

  @override
  State<VehicleDropDownForm> createState() => _VehicleDropDownFormState();
}

class _VehicleDropDownFormState extends State<VehicleDropDownForm> {
  String _registrationNumber = "";

  @override
  void initState() {
    super.initState();
    _registrationNumber = widget.initialSelection.registrationNumber;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      onChanged: (String? newValue) {
        setState(() => _registrationNumber = newValue!);
        widget.onVehicleSelected(
          widget.vehicles.firstWhere(
            (vehicle) => vehicle.registrationNumber == _registrationNumber,
          ),
        );
      },
      validator: (String? value) {
        if (value == null || value == "") {
          return "Vehicle is required";
        }
        return null;
      },
      value: _registrationNumber,
      decoration: InputDecoration(labelText: "Vehicle"),
      items: widget.vehicles.map<DropdownMenuItem<String>>((Vehicle vehicle) {
        return DropdownMenuItem<String>(
          value: vehicle.registrationNumber,
          child: Text(
            vehicle.registrationNumber,
            style: TextStyle(
              fontWeight: _registrationNumber == vehicle.registrationNumber
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}
