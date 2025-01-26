import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';

import '../domain/parking_tab.dart';
import '../state/parking_list_bloc.dart';
import '../state/parking_tab_cubit.dart';

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
    final selectedTab = context.read<ParkingTabCubit>().state;
    _tabController = TabController(
      length: ParkingTab.values.length,
      vsync: this,
      initialIndex: selectedTab.index,
    );
    _onTabChange();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    final selectedTab = context.read<ParkingTabCubit>().state;
    switch (selectedTab) {
      case ParkingTab.active:
        context.read<ParkingListBloc>().add(ParkingListLoadActiveItems());
        break;
      case ParkingTab.all:
        context.read<ParkingListBloc>().add(ParkingListLoadAllItems());
        break;
      case ParkingTab.search:
        context.read<ParkingListBloc>().add(ParkingListSearchInitial());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          onTap: (int index) {
            context.read<ParkingTabCubit>().changeTab(ParkingTab.values[index]);
            _onTabChange();
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
