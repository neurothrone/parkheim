import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/dark_mode_cubit.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final darkModeCubit = context.read<DarkModeCubit>();

    return SwitchListTile(
      onChanged: (_) => darkModeCubit.toggleDarkMode(),
      value: darkModeCubit.isDarkMode,
      title: Text("Dark Mode"),
      // tileColor: Colors.deepPurple.shade50,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 5.0,
      ),
    );
  }
}
