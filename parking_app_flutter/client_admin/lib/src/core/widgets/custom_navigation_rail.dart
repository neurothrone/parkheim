import 'package:flutter/material.dart';

import '../enums/screen.dart';

class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({
    super.key,
    required this.selectedScreen,
    required this.onScreenSelected,
  });

  final Screen selectedScreen;
  final Function(Screen) onScreenSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedScreen.index,
      groupAlignment: -1.0,
      onDestinationSelected: (int index) {
        onScreenSelected(Screen.fromIndex(index));
      },
      labelType: NavigationRailLabelType.all,
      destinations: Screen.values
          .map((screen) => NavigationRailDestination(
                icon: Icon(screen.icon),
                selectedIcon: Icon(screen.selectedIcon),
                label: Text(screen.label),
              ))
          .toList(),
    );
  }
}
