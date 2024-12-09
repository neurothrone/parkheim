import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../spaces/widgets/parking_space_list.dart';

class MostPopularParkingSpaceList extends StatelessWidget {
  const MostPopularParkingSpaceList({
    super.key,
    required this.limit,
  });

  final int limit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ParkingSpace>>(
      future: RemoteParkingRepository.instance.getMostPopularParkingSpaces(
        limit: limit,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final spaces = snapshot.data!;
          if (spaces.isEmpty) {
            return const ListTile(
              title: Text("No parking spaces available."),
            );
          }

          return ParkingSpaceList(
            spaces: spaces,
            shrinkWrap: true,
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
