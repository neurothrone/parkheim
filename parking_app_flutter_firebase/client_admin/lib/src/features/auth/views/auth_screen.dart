import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/widgets/widgets.dart';
import '../state/auth_cubit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppConstants.appName),
      body: Center(
        child: FilledButton(
          onPressed: context.read<AuthCubit>().signIn,
          child: Text("Sign in"),
        ),
      ),
    );
  }
}
