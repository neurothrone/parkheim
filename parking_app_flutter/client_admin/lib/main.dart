import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/core/navigation/navigation_rail_provider.dart';
import 'src/features/auth/state/auth_provider.dart';
import 'src/features/parkings/state/parking_search_text_provider.dart';
import 'src/features/parkings/state/parking_tab_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationRailProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ParkingTabProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ParkingSearchTextProvider(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}
