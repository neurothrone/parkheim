import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/widgets/widgets.dart';
import '../state/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Authentication"),
      body: Center(
        child: FilledButton(
          onPressed: Provider.of<AuthProvider>(context).signIn,
          child: Text("Sign in"),
        ),
      ),
    );
  }
}
