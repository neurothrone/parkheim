import 'package:flutter/material.dart';

enum Screen {
  people,
  vehicles,
  spaces,
  parkings;

  factory Screen.fromIndex(int index) => switch (index) {
        0 => people,
        1 => vehicles,
        2 => spaces,
        _ => parkings,
      };

  String get label => switch (this) {
        people => "People",
        vehicles => "Vehicles",
        spaces => "Spaces",
        parkings => "Parkings",
      };

  IconData get icon => switch (this) {
        people => Icons.people_outline,
        vehicles => Icons.car_rental_outlined,
        spaces => Icons.space_dashboard_outlined,
        parkings => Icons.local_parking_outlined,
      };

  IconData get selectedIcon => switch (this) {
        people => Icons.people_rounded,
        vehicles => Icons.car_rental_rounded,
        spaces => Icons.space_dashboard_rounded,
        parkings => Icons.local_parking_rounded,
      };
}
