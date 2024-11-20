import 'package:flutter/material.dart';

import '../../../common/utils/utils.dart';
import '../../../common/widgets/widgets.dart';

class AuthForm extends StatelessWidget with EmailValidator, PasswordValidator {
  AuthForm({
    super.key,
    required this.onFormSubmitted,
    required this.buttonText,
  });

  final Function(String username, String password) onFormSubmitted;
  final String buttonText;

  final _formKey = GlobalKey<FormState>();

  void _onFormSubmitted(String email, String password) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    onFormSubmitted(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: emailController,
            validator: validateEmail,
            labelText: "Email",
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: emailController,
            validator: validatePassword,
            labelText: "Password",
            obscureText: true,
          ),
          const SizedBox(height: 20),
          CustomFilledButton(
            onPressed: () => _onFormSubmitted(
              emailController.text,
              passwordController.text,
            ),
            text: buttonText,
          ),
        ],
      ),
    );
  }
}
