import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import 'parking_list.dart';

class ActiveParkingItems extends StatelessWidget {
  const ActiveParkingItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Parking>>(
        future: RemoteParkingRepository.instance.findActiveParkings(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final parkings = snapshot.data!;
            if (parkings.isEmpty) {
              return const Center(
                child: Text("No active parkings available."),
              );
            }

            return ParkingList(parkings: parkings);
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
