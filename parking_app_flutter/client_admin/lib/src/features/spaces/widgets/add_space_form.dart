import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

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

  final RemoteParkingSpaceRepository _repository =
      RemoteParkingSpaceRepository.instance;

  bool _isLoading = false;

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

  Future<void> _onFormSubmitted() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await _repository.create(
      ParkingSpace(
        id: 0,
        address: _addressController.text,
        pricePerHour: double.tryParse(_pricePerHourController.text) ?? 0.0,
      ),
    );

    setState(() => _isLoading = false);

    result.when(
      success: (ParkingSpace space) {
        Navigator.of(context).pop();
        SnackBarService.showSuccess(context, "Person added successfully");
      },
      failure: (String error) => SnackBarService.showError(context, error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _isLoading
          ? CenteredProgressIndicator()
          : Column(
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
  }
}
