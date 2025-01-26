import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_widgets/shared_widgets.dart';

import '../../spaces/widgets/parking_space_list.dart';
import '../state/most_popular_spaces_bloc.dart';

class MostPopularParkingSpaceList extends StatelessWidget {
  const MostPopularParkingSpaceList({
    super.key,
    required this.limit,
  });

  final int limit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MostPopularSpacesBloc, MostPopularSpacesState>(
      builder: (context, state) {
        if (state is MostPopularSpacesLoaded) {
          final spaces = state.spaces;
          if (spaces.isEmpty) {
            return const ListTile(
              title: Text("No parking spaces available."),
            );
          }

          return ParkingSpaceList(
            spaces: spaces,
            shrinkWrap: true,
          );
        }

        if (state is MostPopularSpacesLoadFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
