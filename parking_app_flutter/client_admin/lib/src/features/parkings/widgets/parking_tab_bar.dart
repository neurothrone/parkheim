import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shared/shared.dart';

import '../domain/parking_tab.dart';
import '../state/parking_tab_provider.dart';

class ParkingTabBar extends StatefulWidget {
  const ParkingTabBar({super.key});

  @override
  State<ParkingTabBar> createState() => _ParkingTabBarState();
}

class _ParkingTabBarState extends State<ParkingTabBar>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final parkingTabProvider =
        Provider.of<ParkingTabProvider>(context, listen: false);
    _tabController = TabController(
      length: ParkingTab.values.length,
      vsync: this,
      initialIndex: parkingTabProvider.selectedTab.index,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          onTap: (int index) {
            Provider.of<ParkingTabProvider>(context, listen: false)
                .changeTab(ParkingTab.values[index]);
          },
          controller: _tabController,
          tabs: [
            ...ParkingTab.values.map((tab) => Tab(text: tab.name.capitalized)),
          ],
        ),
      ],
    );
  }
}
