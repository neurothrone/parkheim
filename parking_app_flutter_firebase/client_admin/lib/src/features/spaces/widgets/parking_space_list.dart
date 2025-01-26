import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';

import '../state/space_history_bloc.dart';
import '../views/space_details_screen.dart';

class ParkingSpaceList extends StatelessWidget {
  const ParkingSpaceList({
    super.key,
    required this.spaces,
    this.shrinkWrap = false,
  });

  final List<ParkingSpace> spaces;
  final bool shrinkWrap;

  void _onNavigateToDetailsScreen(BuildContext context, ParkingSpace space) {
    // Navigate to the space details screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SpaceDetailsScreen(
          space: space,
        ),
      ),
    );

    // Load the history for that space
    context.read<SpaceHistoryBloc>().add(SpaceHistoryLoad(space: space));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      itemCount: spaces.length,
      itemBuilder: (_, int index) {
        final space = spaces[index];
        return ListTile(
          onTap: () => _onNavigateToDetailsScreen(context, space),
          title: Text(space.address),
          subtitle: Text("Price per hour: \$${space.pricePerHour}"),
          trailing: Icon(Icons.chevron_right_rounded),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 0),
    );
  }
}
