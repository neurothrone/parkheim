import 'package:flutter/material.dart';

import 'common/navigation/app_router.dart';
import 'common/theme/app_theme.dart';
import 'features/parkings/parkings_screen.dart';
import 'features/people/people_screen.dart';
import 'common/navigation/bottom_tab.dart';
import 'features/spaces/spaces_screen.dart';
import 'features/vehicles/vehicles_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  BottomTab _selectedScreen = BottomTab.people;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Parking App - User",
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.config,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Parking App - User",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: switch (_selectedScreen) {
        BottomTab.people => PeopleScreen(
            selectedScreen: _selectedScreen,
            onScreenSelected: (BottomTab newScreen) {
              setState(() => _selectedScreen = newScreen);
            },
          ),
        BottomTab.vehicles => VehiclesScreen(
            selectedScreen: _selectedScreen,
            onScreenSelected: (BottomTab newScreen) {
              setState(() => _selectedScreen = newScreen);
            },
          ),
        BottomTab.spaces => SpacesScreen(
            selectedScreen: _selectedScreen,
            onScreenSelected: (BottomTab newScreen) {
              setState(() => _selectedScreen = newScreen);
            },
          ),
        BottomTab.parkings => ParkingsScreen(
            selectedScreen: _selectedScreen,
            onScreenSelected: (BottomTab newScreen) {
              setState(() => _selectedScreen = newScreen);
            },
          ),
      },
    );
  }
}
