import 'package:flutter/material.dart';

import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

class ParkingsRevenueListTile extends StatelessWidget {
  const ParkingsRevenueListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: RemoteParkingRepository.instance.getTotalRevenueFromParkings(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final totalRevenue = snapshot.data!;
          return ListTile(
            title: Text(
              "Total revenue:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Text(
              "\$$totalRevenue",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
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
