import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

import '../views/parking_details_screen.dart';

class ParkingList extends StatelessWidget {
  const ParkingList({
    super.key,
    required this.parkings,
  });

  final List<Parking> parkings;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: parkings.length,
      itemBuilder: (_, int index) {
        final parking = parkings[index];
        return ListTile(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ParkingDetailsScreen(
                parking: parking,
              ),
            ),
          ),
          title: Text(parking.startTime.toIso8601String()),
          subtitle: Text(parking.endTime?.toIso8601String() ?? "Ongoing"),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 0),
    );
  }
}
