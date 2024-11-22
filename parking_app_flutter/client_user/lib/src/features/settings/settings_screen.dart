import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/widgets/widgets.dart';
import '../auth/bloc/auth_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Settings",
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => context.read<AuthBloc>().add(AuthSignOut()),
        ),
      ],
      bottomNavigationBar: CustomNavigationBar(),
      child: Center(
        child: Text("Settings"),
      ),
    );
  }
}
