import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

import '../../../core/widgets/widgets.dart';
import '../domain/parking_tab.dart';
import '../widgets/active_parking_items.dart';
import '../widgets/available_space_items.dart';
import '../widgets/history_parking_items.dart';

class ParkingsScreen extends StatelessWidget {
  const ParkingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ParkingTab.values.length,
      child: CustomScaffold(
        title: "Parkings",
        bottom: TabBar(
          tabs: [
            ...ParkingTab.values.map((tab) => Tab(text: tab.name.capitalized)),
          ],
        ),
        bottomNavigationBar: CustomNavigationBar(),
        child: TabBarView(
          children: [
            ActiveParkingItems(),
            AvailableSpaceItems(),
            HistoryParkingItems(),
          ],
        ),
      ),
    );
  }
}
