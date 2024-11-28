import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

import '../views/space_details_screen.dart';

final List<ParkingSpace> parkingSpaces = [
  ParkingSpace(id: 1, address: "Address 1", pricePerHour: 2.5),
  ParkingSpace(id: 2, address: "Address 2", pricePerHour: 3.5),
  ParkingSpace(id: 3, address: "Address 3", pricePerHour: 5.5),
];

class ParkingSpaceList extends StatelessWidget {
  const ParkingSpaceList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: parkingSpaces.length,
      itemBuilder: (_, int index) {
        return ListTile(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SpaceDetailsScreen(
                space: parkingSpaces[index],
              ),
            ),
          ),
          title: Text(parkingSpaces[index].address),
          subtitle: Text(
            "Price per hour: \$${parkingSpaces[index].pricePerHour}",
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 0),
    );
  }
}
