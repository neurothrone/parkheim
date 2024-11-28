import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'core/navigation/navigation_rail_provider.dart';
import 'features/parkings/parkings_screen.dart';
import 'features/people/people_screen.dart';
import 'core/navigation/navigation_rail_tab.dart';
import 'features/spaces/views/spaces_screen.dart';
import 'features/vehicles/vehicles_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Parking App - Admin",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Consumer(builder: (context, NavigationRailProvider provider, _) {
        return switch (provider.selectedTab) {
          NavigationRailTab.people => PeopleScreen(),
          NavigationRailTab.vehicles => VehiclesScreen(),
          NavigationRailTab.spaces => SpacesScreen(),
          NavigationRailTab.parkings => ParkingsScreen(),
        };
      }),
    );
  }
}
