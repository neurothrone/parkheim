import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_client_auth/shared_client_auth.dart';

import '../../../core/constants/constants.dart';
import '../state/auth_screen_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: AppConstants.appName,
      child: SingleChildScrollView(
        keyboardDismissBehavior: Platform.isIOS
            ? ScrollViewKeyboardDismissBehavior.onDrag
            : ScrollViewKeyboardDismissBehavior.manual,
        padding: const EdgeInsets.all(20),
        child: SignUpContent(),
      ),
    );
  }
}

class SignUpContent extends StatelessWidget {
  const SignUpContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Join us or else!",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        AuthForm(
          onFormSubmitted: (String email, String password) {
            context
                .read<AuthBloc>()
                .add(AuthSignUp(email: email, password: password));
          },
          buttonText: "Join",
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already one of us?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextButton(
              onPressed: () => context.read<AuthScreenCubit>().showLogin(),
              child: Text(
                "Log in!",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
