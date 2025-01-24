import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../state/space_history_bloc.dart';
import 'parking_history_list_tile.dart';

class ParkingHistoryList extends StatelessWidget {
  const ParkingHistoryList({
    super.key,
    required this.space,
  });

  final ParkingSpace space;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpaceHistoryBloc, SpaceHistoryState>(
      builder: (context, state) {
        if (state is SpaceHistoryLoaded) {
          final parkings = state.parkings;
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

        if (state is SpaceHistoryFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return const CenteredProgressIndicator();
      },
    );
  }
}
