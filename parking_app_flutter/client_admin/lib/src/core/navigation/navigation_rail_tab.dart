import 'package:flutter/material.dart';

enum NavigationRailTab {
  spaces,
  parkings,
  people,
  vehicles;

  factory NavigationRailTab.fromIndex(int index) => switch (index) {
        0 => spaces,
        1 => parkings,
        2 => people,
        _ => vehicles,
      };

  static NavigationRailTab get defaultTab => spaces;

  String get label => switch (this) {
        spaces => "Spaces",
        parkings => "Parkings",
        people => "People",
        vehicles => "Vehicles",
      };

  IconData get icon => switch (this) {
        spaces => Icons.space_dashboard_outlined,
        parkings => Icons.local_parking_outlined,
        people => Icons.people_outline,
        vehicles => Icons.car_rental_outlined,
      };

  IconData get selectedIcon => switch (this) {
        spaces => Icons.space_dashboard_rounded,
        parkings => Icons.local_parking_rounded,
        people => Icons.people_rounded,
        vehicles => Icons.car_rental_rounded,
      };
}
