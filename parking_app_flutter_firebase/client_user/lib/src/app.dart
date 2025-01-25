import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/constants.dart';
import 'core/routing/routing.dart';
import 'core/theme/theme.dart';
import 'features/settings/state/dark_mode_cubit.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkModeCubit = context.watch<DarkModeCubit>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: darkModeCubit.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: AppRouter.config(context),
    );
  }
}
