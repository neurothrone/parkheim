import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routing/routing.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Parko",
      child: SingleChildScrollView(
        keyboardDismissBehavior: Platform.isIOS
            ? ScrollViewKeyboardDismissBehavior.onDrag
            : ScrollViewKeyboardDismissBehavior.manual,
        padding: const EdgeInsets.all(20),
        child: SignInContent(),
      ),
    );
  }
}

class SignInContent extends StatelessWidget {
  const SignInContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Welcome!\nThere is no turning back now.",
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        AuthForm(
          onFormSubmitted: (String email, String password) {
            context
                .read<AuthBloc>()
                .add(AuthSignIn(email: email, password: password));
          },
          buttonText: "Log in",
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Not one of us?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextButton(
              onPressed: () => AppRouter.go(context, AppRoute.register),
              child: Text(
                "Join us!",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
