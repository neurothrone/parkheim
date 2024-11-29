import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import 'parking_list.dart';

class AllParkingItems extends StatelessWidget {
  const AllParkingItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<Result<List<Parking>, String>>(
        future: RemoteParkingRepository.instance.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final result = snapshot.data!;
            return result.when(
              success: (List<Parking> parkings) {
                if (parkings.isEmpty) {
                  return const Center(
                    child: Text("No parkings available."),
                  );
                }

                return ParkingList(parkings: parkings);
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
