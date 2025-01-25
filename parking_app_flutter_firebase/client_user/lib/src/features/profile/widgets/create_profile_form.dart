import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_widgets/shared_widgets.dart';

import '../state/create_profile_bloc.dart';

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

    context.read<CreateProfileBloc>().add(
          CreateProfileSubmit(
            name: _nameController.text,
            socialSecurityNumber: _socialSecurityNumberController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: wrap with bloc listener
    return BlocListener<CreateProfileBloc, CreateProfileState>(
      listener: (context, state) {
        if (state is CreateProfileSuccess) {
          SnackBarService.showSuccess(context, "Profile created successfully");
        } else if (state is CreateProfileFailure) {
          SnackBarService.showError(context, state.message);
        }
      },
      child: Form(
        key: _formKey,
        child: BlocBuilder<CreateProfileBloc, CreateProfileState>(
          builder: (context, state) {
            if (state is CreateProfileLoading) {
              return CenteredProgressIndicator();
            }

            return Column(
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
            );
          },
        ),
      ),
    );

    // return Form(
    //   key: _formKey,
    //   child: _isLoading
    //       ? CenteredProgressIndicator()
    //       : Column(
    //           children: [
    //             CustomTextFormField(
    //               onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(
    //                 _socialSecurityNumberNode,
    //               ),
    //               controller: _nameController,
    //               validator: (String? value) => validateString(value, "Name"),
    //               labelText: "Name",
    //               textInputAction: TextInputAction.next,
    //             ),
    //             const SizedBox(height: 20),
    //             CustomTextFormField(
    //               onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
    //               controller: _socialSecurityNumberController,
    //               validator: validateSocialSecurityNumber,
    //               labelText: "Social Security Number",
    //               focusNode: _socialSecurityNumberNode,
    //               textInputAction: TextInputAction.done,
    //             ),
    //             const SizedBox(height: 20),
    //             CustomFilledButton(
    //               onPressed: _onFormSubmitted,
    //               text: "Add",
    //             ),
    //           ],
    //         ),
    // );
  }
}
