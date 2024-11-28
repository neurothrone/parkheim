import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

import '../../core/widgets/widgets.dart';
import 'add_space_screen.dart';

class SpacesScreen extends StatelessWidget {
  const SpacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Spaces"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddSpaceScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          CustomNavigationRail(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: ParkingSpaceList(),
          ),
        ],
      ),
    );
  }
}

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
          title: Text(parkingSpaces[index].address),
          subtitle:
              Text("Price per hour: \$${parkingSpaces[index].pricePerHour}"),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }
}
