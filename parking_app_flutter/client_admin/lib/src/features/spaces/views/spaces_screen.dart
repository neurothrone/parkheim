import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import '../widgets/parking_space_list.dart';
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
