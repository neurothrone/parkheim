import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import 'parking_history_list_tile.dart';

class ParkingHistoryList extends StatelessWidget {
  const ParkingHistoryList({
    super.key,
    required this.space,
  });

  final ParkingSpace space;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Parking>>(
      future: RemoteParkingRepository.instance.getHistoryForParkingSpace(space),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final parkings = snapshot.data!;
          if (parkings.isEmpty) {
            return const Center(
              child: Text("No parkings available."),
            );
          }

          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: parkings.length,
            itemBuilder: (_, int index) {
              final parking = parkings[index];
              return ParkingHistoryListTile(parking: parking);
            },
            separatorBuilder: (_, __) => const Divider(height: 0),
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
