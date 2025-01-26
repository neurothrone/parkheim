import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/navigation/bottom_navigation_cubit.dart';
import '../cubits/navigation/bottom_tab.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bottomTabCubit = context.watch<BottomNavigationCubit>();

    return NavigationBar(
      onDestinationSelected: (int index) {
        bottomTabCubit.changeTab(BottomTab.fromIndex(index));
      },
      selectedIndex: bottomTabCubit.state.index,
      destinations: BottomTab.values
          .map(
            (screen) => NavigationDestination(
              icon: Icon(
                screen.icon,
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
