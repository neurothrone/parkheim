import 'package:flutter/material.dart';

import '../../../common/navigation/navigation.dart';
import '../../../common/widgets/widgets.dart';
import '../widgets/auth_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Parko",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome! There is no turning back now.",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          AuthForm(
            onFormSubmitted: (String username, String password) {},
            buttonText: "Log in",
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Not one of us?"),
              TextButton(
                onPressed: () => AppRouter.go(context, AppRoute.register),
                child: const Text("Join us!"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
