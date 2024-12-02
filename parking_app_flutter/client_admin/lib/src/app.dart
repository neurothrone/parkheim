import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'core/constants/constants.dart';
import 'core/navigation/navigation.dart';
import 'features/auth/state/auth_provider.dart';
import 'features/auth/views/auth_screen.dart';
import 'features/parkings/views/parkings_screen.dart';
import 'features/people/views/people_screen.dart';
import 'features/spaces/views/spaces_screen.dart';
import 'features/statistics/views/statistics_screen.dart';
import 'features/vehicles/views/vehicles_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "${AppConstants.appName} - Admin",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Consumer(
        builder: (context, AuthProvider provider, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: provider.isAuthenticated ? MainContent() : AuthScreen(),
          );
        },
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.watch<NavigationRailProvider>().selectedTab;
    return switch (selectedTab) {
      NavigationRailTab.people => PeopleScreen(),
      NavigationRailTab.vehicles => VehiclesScreen(),
      NavigationRailTab.statistics => StatisticsScreen(),
      NavigationRailTab.spaces => SpacesScreen(),
      NavigationRailTab.parkings => ParkingsScreen(),
    };
  }
}
