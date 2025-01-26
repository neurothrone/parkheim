import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_client_auth/shared_client_auth.dart';

import '../navigation/navigation.dart';

class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    final selection = context.read<NavigationRailCubit>().state;

    return NavigationRail(
      selectedIndex: selection.index,
      groupAlignment: -1.0,
      onDestinationSelected: (int index) {
        context
            .read<NavigationRailCubit>()
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
            onPressed: () => context.read<AuthBloc>().add(AuthSignOut()),
            icon: Icon(Icons.logout_rounded),
          ),
        ),
      ),
    );
  }
}
