import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/widgets.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../state/dark_mode_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final darkModeCubit = context.read<DarkModeCubit>();

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
            SwitchListTile(
              onChanged: (_) => darkModeCubit.toggleDarkMode(),
              value: darkModeCubit.isDarkMode,
              title: Text("Dark Mode"),
              tileColor: Colors.deepPurple.shade50,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5.0,
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
