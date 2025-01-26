import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_widgets/shared_widgets.dart';

import '../state/parking_list_bloc.dart';
import 'parking_list.dart';

class AllParkingItems extends StatelessWidget {
  const AllParkingItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingListBloc, ParkingListState>(
      builder: (context, state) {
        if (state is ParkingListLoaded) {
          if (state.parkings.isEmpty) {
            return const Center(
              child: Text("No parkings available."),
            );
          }
          return ParkingList(parkings: state.parkings);
        }

        if (state is ParkingListFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
