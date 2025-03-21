import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../state/vehicle_list_bloc.dart';

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({super.key});

  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm>
    with RegistrationNumberValidator {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _registrationNumberController;
  VehicleType _vehicleType = VehicleType.car;

  @override
  void initState() {
    super.initState();

    _registrationNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _registrationNumberController.dispose();

    super.dispose();
  }

  Future<void> _onFormSubmitted() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<VehicleListBloc>().add(
          VehicleListAddItem(
            registrationNumber: _registrationNumberController.text,
            vehicleType: _vehicleType,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleListBloc, VehicleListState>(
      listener: (context, state) {
        if (state is VehicleListFailure) {
          SnackBarService.showError(context, state.message);
        } else if (state is VehicleListAdded) {
          Navigator.of(context).pop();
          SnackBarService.showSuccess(context, "Vehicle Added");
        }
      },
      child: BlocBuilder<VehicleListBloc, VehicleListState>(
        builder: (context, state) {
          if (state is VehicleListLoading) {
            return const CenteredProgressIndicator();
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  controller: _registrationNumberController,
                  validator: validateRegistrationNumber,
                  labelText: "Registration number",
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                SegmentedButton<VehicleType>(
                  onSelectionChanged: (Set<VehicleType> newSelection) {
                    setState(() => _vehicleType = newSelection.first);
                  },
                  selected: <VehicleType>{_vehicleType},
                  segments: const <ButtonSegment<VehicleType>>[
                    ButtonSegment<VehicleType>(
                      value: VehicleType.car,
                      label: Text("Car"),
                      icon: Icon(Icons.directions_car_rounded),
                    ),
                    ButtonSegment<VehicleType>(
                      value: VehicleType.motorcycle,
                      label: Text("Motorcycle"),
                      icon: Icon(Icons.motorcycle_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomFilledButton(
                  onPressed: _onFormSubmitted,
                  text: "Add",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
