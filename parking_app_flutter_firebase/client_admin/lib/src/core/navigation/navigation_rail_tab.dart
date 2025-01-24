import 'package:flutter/material.dart';

enum NavigationRailTab {
  spaces,
  parkings,
  statistics;

  factory NavigationRailTab.fromIndex(int index) => switch (index) {
        0 => spaces,
        1 => parkings,
        _ => statistics,
      };

  static NavigationRailTab get defaultTab => spaces;

  String get label => switch (this) {
        spaces => "Spaces",
        parkings => "Parkings",
        statistics => "Statistics",
      };

  IconData get icon => switch (this) {
        spaces => Icons.space_dashboard_outlined,
        parkings => Icons.local_parking_outlined,
        statistics => Icons.analytics_outlined,
      };

  IconData get selectedIcon => switch (this) {
        spaces => Icons.space_dashboard_rounded,
        parkings => Icons.local_parking_rounded,
        statistics => Icons.analytics_rounded,
      };
}
