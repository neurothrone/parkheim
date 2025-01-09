import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_widgets/shared_widgets.dart';

import '../state/active_parkings/active_parkings_bloc.dart';
import 'active_parking_list_tile.dart';

class ActiveParkingItems extends StatefulWidget {
  const ActiveParkingItems({super.key});

  @override
  State<ActiveParkingItems> createState() => _ActiveParkingItemsState();
}

class _ActiveParkingItemsState extends State<ActiveParkingItems> {
  @override
  void initState() {
    super.initState();
    context.read<ActiveParkingsBloc>().add(ActiveParkingLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveParkingsBloc, ActiveParkingsState>(
      builder: (context, state) {
        if (state is ActiveParkingsLoading) {
          return CenteredProgressIndicator();
        } else if (state is ActiveParkingsLoaded) {
          final parkings = state.parkings;
          if (parkings.isEmpty) {
            return Center(
              child: Text("No active parkings available."),
            );
          }

          return ListView.separated(
            itemCount: parkings.length,
            itemBuilder: (context, index) {
              final parking = parkings[index];
              return ActiveParkingListTile(parking: parking);
            },
            separatorBuilder: (context, index) => const Divider(height: 0),
          );
        } else if (state is ActiveParkingsFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
