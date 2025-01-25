import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_widgets/shared_widgets.dart';

import '../state/parking_history/parking_history_bloc.dart';
import 'history_parking_list_tile.dart';

class HistoryParkingItems extends StatefulWidget {
  const HistoryParkingItems({super.key});

  @override
  State<HistoryParkingItems> createState() => _HistoryParkingItemsState();
}

class _HistoryParkingItemsState extends State<HistoryParkingItems> {
  @override
  void initState() {
    super.initState();
    context.read<ParkingHistoryBloc>().add(ParkingHistoryLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingHistoryBloc, ParkingHistoryState>(
      builder: (context, state) {
        if (state is ParkingHistoryLoaded) {
          if (state.parkings.isEmpty) {
            return Center(
              child: Text("No parking spaces available."),
            );
          }

          return ListView.separated(
            itemCount: state.parkings.length,
            itemBuilder: (context, index) {
              final parking = state.parkings[index];
              return HistoryParkingListTile(parking: parking);
            },
            separatorBuilder: (context, index) => const Divider(height: 0),
          );
        } else if (state is ParkingHistoryFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
