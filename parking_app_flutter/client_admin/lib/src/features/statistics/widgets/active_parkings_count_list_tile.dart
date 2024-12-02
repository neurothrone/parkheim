import 'package:flutter/material.dart';

import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

class ActiveParkingsCountListTile extends StatelessWidget {
  const ActiveParkingsCountListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: RemoteParkingRepository.instance.getActiveParkingsCount(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final count = snapshot.data!;
          return ListTile(
            title: Text(
              "Active parkings:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Text(
              count.toString(),
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
