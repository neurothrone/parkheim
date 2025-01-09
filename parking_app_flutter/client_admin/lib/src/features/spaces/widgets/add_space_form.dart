import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../state/spaces_list_bloc.dart';

class AddSpaceForm extends StatefulWidget {
  const AddSpaceForm({super.key});

  @override
  State<AddSpaceForm> createState() => _AddSpaceFormState();
}

class _AddSpaceFormState extends State<AddSpaceForm>
    with RequiredStringValidator, PriceValidator {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _addressController;
  late final TextEditingController _pricePerHourController;

  late final FocusNode _pricePerHourNode;

  @override
  void initState() {
    super.initState();

    _addressController = TextEditingController();
    _pricePerHourController = TextEditingController();

    _pricePerHourNode = FocusNode();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _pricePerHourController.dispose();

    _pricePerHourNode.dispose();

    super.dispose();
  }

  void _onFormSubmitted() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<SpacesListBloc>().add(
          SpacesListAddItem(
            space: ParkingSpace(
              id: 0,
              address: _addressController.text,
              pricePerHour:
                  double.tryParse(_pricePerHourController.text) ?? 0.0,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpacesListBloc, SpacesListState>(
      listener: (context, state) {
        if (state is SpacesListFailure) {
          SnackBarService.showError(context, state.message);
        } else if (state is! SpacesListLoading) {
          Navigator.of(context).pop();
          SnackBarService.showSuccess(
              context, "Parking space added successfully");
        }
      },
      child: BlocBuilder<SpacesListBloc, SpacesListState>(
        builder: (context, state) {
          if (state is SpacesListLoading) {
            return CenteredProgressIndicator();
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(
                    _pricePerHourNode,
                  ),
                  controller: _addressController,
                  validator: (String? value) =>
                      validateString(value, "Address"),
                  labelText: "Address",
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  controller: _pricePerHourController,
                  validator: validatePrice,
                  labelText: "Price per hour",
                  focusNode: _pricePerHourNode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
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
