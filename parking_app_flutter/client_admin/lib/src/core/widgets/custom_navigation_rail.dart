import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../navigation/navigation_rail_tab.dart';
import '../navigation/navigation_rail_provider.dart';

class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    final selection =
        Provider.of<NavigationRailProvider>(context, listen: false).selectedTab;
    return NavigationRail(
      selectedIndex: selection.index,
      groupAlignment: -1.0,
      onDestinationSelected: (int index) {
        Provider.of<NavigationRailProvider>(context, listen: false)
            .changeTab(NavigationRailTab.fromIndex(index));
      },
      labelType: NavigationRailLabelType.all,
      destinations: NavigationRailTab.values
          .map((screen) => NavigationRailDestination(
                icon: Icon(screen.icon),
                selectedIcon: Icon(screen.selectedIcon),
                label: Text(screen.label),
              ))
          .toList(),
    );
  }
}
