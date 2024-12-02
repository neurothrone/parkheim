import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import '../widgets/active_parkings_count_list_tile.dart';
import '../widgets/most_popular_parking_space_list.dart';
import '../widgets/parkings_revenue_list_tile.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Statistics"),
      body: Row(
        children: [
          CustomNavigationRail(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: ListView(
              // shrinkWrap: true,
              children: [
                ActiveParkingsCountListTile(),
                Divider(height: 0),
                ParkingsRevenueListTile(),
                Divider(height: 0),
                ListTile(
                  title: Text(
                    "Most Popular Parking Spaces",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(decoration: TextDecoration.underline),
                  ),
                ),
                Divider(height: 0),
                MostPopularParkingSpaceList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
