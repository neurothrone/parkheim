import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._internal();

  static ThemeData get lightTheme => ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        primaryColorDark: Colors.deepPurple[700],
        primaryColorLight: Colors.deepPurple[300],
        scaffoldBackgroundColor: Colors.white.withOpacity(0.95),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple.shade100,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.deepPurple.shade100,
          surfaceTintColor: Colors.deepPurple.shade100,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        primaryColorDark: Colors.deepPurple[700],
        primaryColorLight: Colors.deepPurple[300],
        scaffoldBackgroundColor: Colors.white10,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.deepPurple,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.black,
          indicatorColor: Colors.deepPurple.shade200,
          // indicatorShape: CircleBorder(),
          elevation: 0,
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return IconThemeData(color: Colors.black);
              }
              return IconThemeData(color: Colors.deepPurple.shade100);
            },
          ),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(color: Colors.deepPurple.shade100),
          ),
        ),
      );
}
