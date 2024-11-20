import 'package:flutter/material.dart';

import '../navigation/bottom_tab.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    super.key,
    required this.selectedScreen,
    required this.onScreenSelected,
  });

  final BottomTab selectedScreen;
  final Function(BottomTab) onScreenSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        onScreenSelected(BottomTab.fromIndex(index));
      },
      selectedIndex: selectedScreen.index,
      destinations: BottomTab.values
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
