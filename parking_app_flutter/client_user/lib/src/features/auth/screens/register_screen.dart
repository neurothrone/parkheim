import 'package:flutter/material.dart';

import '../../../common/widgets/widgets.dart';
import '../widgets/auth_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Parko",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Join us or else!",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          AuthForm(
            onFormSubmitted: (String username, String password) {},
            buttonText: "Register",
          ),
        ],
      ),
    );
  }
}
