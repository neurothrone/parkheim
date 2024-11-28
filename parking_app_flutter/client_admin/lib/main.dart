import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/core/navigation/navigation_rail_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NavigationRailProvider(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}
