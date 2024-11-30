import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../core/cubits/app_user/app_user_state.dart';

class CreateProfileForm extends StatefulWidget {
  const CreateProfileForm({super.key});

  @override
  State<CreateProfileForm> createState() => _CreateProfileFormState();
}

class _CreateProfileFormState extends State<CreateProfileForm>
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

    final name = _nameController.text;
    final isAvailable = await _personRepository.isNameAvailable(name);
    if (!isAvailable) {
      setState(() => _isLoading = false);
      SnackBarService.showError(context, "Name is already taken");
      return;
    }

    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(
        _nameController.text,
      );
    } catch (e) {
      setState(() => _isLoading = false);
      SnackBarService.showError(context, e.toString());
      return;
    }

    final result = await _personRepository.create(
      Person(
        id: 0,
        name: name,
        socialSecurityNumber: _socialSecurityNumberController.text,
      ),
    );

    setState(() => _isLoading = false);

    result.when(
      success: (Person person) async {
        final appUserCubit = context.read<AppUserCubit>();
        final user = (appUserCubit.state as AppUserSignedIn).user;
        final updatedUser = user.copyWith(displayName: person.name);
        appUserCubit.updateUser(updatedUser);
        SnackBarService.showSuccess(context, "Profile created successfully");
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
