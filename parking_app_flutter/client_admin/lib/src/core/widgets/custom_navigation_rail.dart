import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../features/auth/state/auth_provider.dart';
import '../navigation/navigation.dart';

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
          .map((tab) => NavigationRailDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: Text(tab.label),
              ))
          .toList(),
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: IconButton(
            onPressed:
                Provider.of<AuthProvider>(context, listen: false).signOut,
            icon: Icon(Icons.logout_rounded),
          ),
        ),
      ),
    );
  }
}
