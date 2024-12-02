import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/widgets/widgets.dart';
import '../domain/parking_tab.dart';
import '../state/parking_tab_provider.dart';
import '../widgets/parking_tab_bar.dart';
import '../widgets/active_parking_items.dart';
import '../widgets/all_parking_items.dart';
import '../widgets/search_parking_items.dart';

class ParkingsScreen extends StatelessWidget {
  const ParkingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Parkings"),
      body: Row(
        children: [
          CustomNavigationRail(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                ParkingTabBar(),
                ParkingTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ParkingTabContent extends StatelessWidget {
  const ParkingTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.watch<ParkingTabProvider>().selectedTab;
    return switch (selectedTab) {
      ParkingTab.active => ActiveParkingItems(),
      ParkingTab.all => AllParkingItems(),
      ParkingTab.search => SearchParkingItems(),
    };
  }
}
