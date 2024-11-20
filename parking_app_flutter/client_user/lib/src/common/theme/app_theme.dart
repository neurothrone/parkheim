import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._internal();

  static ThemeData get lightTheme => ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue[700],
        primaryColorLight: Colors.blue[300],
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue[700],
        primaryColorLight: Colors.blue[300],
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      );
}
