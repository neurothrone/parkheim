import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/constants.dart';
import 'core/navigation/navigation.dart';
import 'features/auth/state/auth_cubit.dart';
import 'features/auth/views/auth_screen.dart';
import 'features/parkings/views/parkings_screen.dart';
import 'features/spaces/views/spaces_screen.dart';
import 'features/statistics/state/active_parking_count_bloc.dart';
import 'features/statistics/state/most_popular_spaces_bloc.dart';
import 'features/statistics/state/parking_revenue_bloc.dart';
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

    // Load statistics
    if (selectedTab == NavigationRailTab.statistics) {
      context.read<ActiveParkingCountBloc>().add(ActiveParkingCountLoad());
      context.read<MostPopularSpacesBloc>().add(MostPopularSpacesLoad());
      context.read<ParkingRevenueBloc>().add(ParkingRevenueLoad());
    }

    return switch (selectedTab) {
      NavigationRailTab.spaces => SpacesScreen(),
      NavigationRailTab.parkings => ParkingsScreen(),
      NavigationRailTab.statistics => StatisticsScreen(),
    };
  }
}
