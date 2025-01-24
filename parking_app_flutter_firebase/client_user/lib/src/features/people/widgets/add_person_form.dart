import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/routing/routing.dart';

class AddPersonForm extends StatefulWidget {
  const AddPersonForm({super.key});

  @override
  State<AddPersonForm> createState() => _AddPersonFormState();
}

class _AddPersonFormState extends State<AddPersonForm>
    with RequiredStringValidator, SocialSecurityNumberValidator {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _socialSecurityNumberController;

  late final FocusNode _socialSecurityNumberNode;

  final RemotePersonRepository _personRepository =
      RemotePersonRepository.instance;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _socialSecurityNumberController = TextEditingController();

    _socialSecurityNumberNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _socialSecurityNumberController.dispose();

    _socialSecurityNumberNode.dispose();

    super.dispose();
  }

  Future<void> _onFormSubmitted() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await _personRepository.create(
      Person(
        id: 0,
        name: _nameController.text,
        socialSecurityNumber: _socialSecurityNumberController.text,
      ),
    );

    setState(() => _isLoading = false);

    result.when(
      success: (Person person) {
        AppRouter.pop(context);
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
                    _socialSecurityNumberNode,
                  ),
                  controller: _nameController,
                  validator: (String? value) => validateString(value, "Name"),
                  labelText: "Name",
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  controller: _socialSecurityNumberController,
                  validator: validateSocialSecurityNumber,
                  labelText: "Social Security Number",
                  focusNode: _socialSecurityNumberNode,
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
