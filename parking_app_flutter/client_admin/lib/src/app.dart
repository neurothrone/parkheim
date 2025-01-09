import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'core/constants/constants.dart';
import 'core/navigation/navigation.dart';
import 'core/navigation/navigation_rail_cubit.dart';
import 'features/auth/state/auth_cubit.dart';
import 'features/auth/views/auth_screen.dart';
import 'features/parkings/views/parkings_screen.dart';
import 'features/spaces/views/spaces_screen.dart';
import 'features/statistics/views/statistics_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthCubit>().state;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "${AppConstants.appName} - Admin",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: authStatus == AuthStatus.authenticated
            ? MainContent()
            : AuthScreen(),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.watch<NavigationRailCubit>().state;
    return switch (selectedTab) {
      NavigationRailTab.statistics => StatisticsScreen(),
      NavigationRailTab.spaces => SpacesScreen(),
      NavigationRailTab.parkings => ParkingsScreen(),
    };
  }
}
