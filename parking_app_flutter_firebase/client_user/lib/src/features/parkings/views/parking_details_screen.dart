import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/widgets/widgets.dart';
import '../widgets/start_parking_form.dart';
import '../widgets/parking_space_details.dart';

class ParkingDetailsScreen extends StatelessWidget {
  const ParkingDetailsScreen({
    super.key,
    required this.space,
  });

  final ParkingSpace space;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Parking",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Hero(
              tag: space.id,
              child: CustomCircleAvatar(icon: Icons.local_parking_rounded),
            ),
            const SizedBox(height: 20.0),
            ParkingSpaceDetails(space: space),
            StartParkingForm(space: space),
          ],
        ),
      ),
    );
  }
}
