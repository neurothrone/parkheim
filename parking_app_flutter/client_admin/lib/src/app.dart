import 'package:flutter/material.dart';

import 'features/parkings/parkings_screen.dart';
import 'features/people/people_screen.dart';
import 'core/enums/screen.dart';
import 'features/spaces/spaces_screen.dart';
import 'features/vehicles/vehicles_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Screen _selectedScreen = Screen.people;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Parking App - Admin",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: switch (_selectedScreen) {
        Screen.people => PeopleScreen(
            selectedScreen: _selectedScreen,
            onScreenSelected: (Screen newScreen) {
              setState(() => _selectedScreen = newScreen);
            },
          ),
        Screen.vehicles => VehiclesScreen(
            selectedScreen: _selectedScreen,
            onScreenSelected: (Screen newScreen) {
              setState(() => _selectedScreen = newScreen);
            },
          ),
        Screen.spaces => SpacesScreen(
            selectedScreen: _selectedScreen,
            onScreenSelected: (Screen newScreen) {
              setState(() => _selectedScreen = newScreen);
            },
          ),
        Screen.parkings => ParkingsScreen(
            selectedScreen: _selectedScreen,
            onScreenSelected: (Screen newScreen) {
              setState(() => _selectedScreen = newScreen);
            },
          ),
      },
    );
  }
}
