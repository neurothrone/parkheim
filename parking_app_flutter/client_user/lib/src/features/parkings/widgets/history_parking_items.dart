import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../core/cubits/app_user/app_user_state.dart';
import 'history_parking_list_tile.dart';

class HistoryParkingItems extends StatelessWidget {
  const HistoryParkingItems({super.key});

  Future<List<Parking>> _findFinishedParkings(BuildContext context) async {
    final appUserCubit = context.read<AppUserCubit>();
    final user = (appUserCubit.state as AppUserSignedIn).user;

    final ownerResult = await RemotePersonRepository.instance
        .findPersonByName(user.displayName!);
    final owner = ownerResult.when(
      success: (person) => person,
      failure: (error) {
        SnackBarService.showError(context, "Error: Owner not found");
        return null;
      },
    );
    if (owner == null) {
      return [];
    }

    return await RemoteParkingRepository.instance
        .findFinishedParkingsForOwner(owner);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Parking>>(
      future: _findFinishedParkings(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final parkings = snapshot.data!;
          if (parkings.isEmpty) {
            return Center(
              child: Text("No parking spaces available."),
            );
          }

          return ListView.separated(
            itemCount: parkings.length,
            itemBuilder: (context, index) {
              final parking = parkings[index];
              return HistoryParkingListTile(parking: parking);
            },
            separatorBuilder: (context, index) => const Divider(height: 0),
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
