import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

import 'parking_list_tile.dart';

class ParkingList extends StatelessWidget {
  const ParkingList({
    super.key,
    required this.parkings,
    this.shrinkWrap = false,
    this.physics,
  });

  final List<Parking> parkings;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: parkings.length,
      itemBuilder: (_, int index) {
        final parking = parkings[index];
        return ParkingListTile(parking: parking);
      },
      separatorBuilder: (_, __) => const Divider(height: 0),
    );
  }
}
