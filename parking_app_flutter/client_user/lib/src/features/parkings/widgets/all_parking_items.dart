import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import 'all_parking_list_tile.dart';

class AllParkingItems extends StatelessWidget {
  const AllParkingItems({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<List<ParkingSpace>, String>>(
      future: RemoteParkingSpaceRepository.instance.getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data!;
          return result.when(
            success: (List<ParkingSpace> spaces) {
              if (spaces.isEmpty) {
                return Center(
                  child: Text("No parking spaces available."),
                );
              }

              return ListView.separated(
                itemCount: spaces.length,
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final space = spaces[index];
                  return AllParkingListTile(space: space);
                },
              );
            },
            failure: (error) => Center(child: Text("Error: $error")),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
