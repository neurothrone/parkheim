import 'package:flutter/material.dart';

import '../enums/screen.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    super.key,
    required this.selectedScreen,
    required this.onScreenSelected,
  });

  final Screen selectedScreen;
  final Function(Screen) onScreenSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        onScreenSelected(Screen.fromIndex(index));
      },
      selectedIndex: selectedScreen.index,
      destinations: Screen.values
          .map(
            (screen) => NavigationDestination(
              icon: Icon(
                screen.icon,
                // color: Colors.grey,
              ),
              selectedIcon: Icon(
                screen.selectedIcon,
                // color: Colors.white,
              ),
              label: screen.label,
            ),
          )
          .toList(),
    );
  }
}
