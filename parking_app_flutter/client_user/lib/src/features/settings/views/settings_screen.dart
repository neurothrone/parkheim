import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/widgets.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../widgets/dark_mode_switch.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Settings",
      actions: [
        IconButton(
          onPressed: () => context.read<AuthBloc>().add(AuthSignOut()),
          icon: const Icon(Icons.logout),
        ),
      ],
      bottomNavigationBar: CustomNavigationBar(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DarkModeSwitch(),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
