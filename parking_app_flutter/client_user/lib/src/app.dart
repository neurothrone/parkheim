import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routing/routing.dart';
import 'core/theme/theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/settings/state/dark_mode_cubit.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserSignedIn());
  }

  @override
  Widget build(BuildContext context) {
    final darkModeCubit = context.watch<DarkModeCubit>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Parking App - User",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: darkModeCubit.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: AppRouter.config(context),
    );
  }
}
