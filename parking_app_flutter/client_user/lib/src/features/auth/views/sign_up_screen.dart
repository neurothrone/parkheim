import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Parko",
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
      ],
    );
  }
}
