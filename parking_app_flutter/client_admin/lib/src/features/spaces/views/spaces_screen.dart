import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/widgets/widgets.dart';
import '../widgets/parking_space_list.dart';
import 'add_space_screen.dart';

Future<void> _generateFakeSpaces() async {
  final spaces = List.generate(
    10,
    (index) => ParkingSpace(
      id: 0,
      address: "Address $index",
      pricePerHour: index * 1.5,
    ),
  );

  for (final space in spaces) {
    await RemoteParkingSpaceRepository.instance.create(space);
  }
}

Future<void> _clearItems() async {
  final result = await RemoteParkingSpaceRepository.instance.getAll();

  result.when(
    success: (List<ParkingSpace> spaces) async {
      for (final space in spaces) {
        await RemoteParkingSpaceRepository.instance.delete(space.id);
      }
    },
    failure: (error) => debugPrint("Error: $error"),
  );
}

class SpacesScreen extends StatelessWidget {
  const SpacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Spaces",
        actions: [
          IconButton(
            onPressed: () async => await _generateFakeSpaces(),
            tooltip: "Generate Demo Data",
            icon: Icon(Icons.refresh_rounded),
          ),
          IconButton(
            onPressed: () async => await _clearItems(),
            tooltip: "Clear Spaces",
            icon: Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddSpaceScreen(),
              ),
            ),
            tooltip: "Add Parking Space",
            icon: Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: Row(
        children: [
          CustomNavigationRail(),
          const VerticalDivider(thickness: 1, width: 1),
          ParkingSpaceItems(),
        ],
      ),
    );
  }
}

class ParkingSpaceItems extends StatelessWidget {
  const ParkingSpaceItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<Result<List<ParkingSpace>, String>>(
        future: RemoteParkingSpaceRepository.instance.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final result = snapshot.data!;
            return result.when(
              success: (List<ParkingSpace> spaces) {
                if (spaces.isEmpty) {
                  return const Center(
                    child: Text("No parking spaces available."),
                  );
                }

                return ParkingSpaceList(spaces: spaces);
              },
              failure: (error) => Center(child: Text("Error: $error")),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return CenteredProgressIndicator();
        },
      ),
    );
  }
}
