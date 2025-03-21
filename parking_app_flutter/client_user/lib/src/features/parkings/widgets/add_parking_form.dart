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
        } else if (state is !AvailableSpacesLoading) {
          Navigator.of(context).pop();
          SnackBarService.showSuccess(context, "Parking started");
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            BlocBuilder<VehicleListBloc, VehicleListState>(
              builder: (context, state) {
                if (state is VehicleListLoaded) {
                  _vehicleId = state.vehicles.first.id;
                  _vehicle = state.vehicles.first;

                  return DropdownButtonFormField<int>(
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
                    items: state.vehicles
                        .map<DropdownMenuItem<int>>((Vehicle vehicle) {
                      return DropdownMenuItem<int>(
                        onTap: () => _vehicle = vehicle,
                        value: vehicle.id,
                        child: Text(vehicle.registrationNumber),
                      );
                    }).toList(),
                  );
                }

                if (state is VehicleListFailure) {
                  return Center(
                    child: Text("Error: ${state.message}"),
                  );
                }

                return const CenteredProgressIndicator();
              },
            ),
            const SizedBox(height: 20),
            CustomFilledButton(
              onPressed: _onFormSubmitted,
              text: "Start Parking",
            ),
          ],
        ),
      ),
    );
  }
}
