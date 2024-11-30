import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../core/cubits/app_user/app_user_state.dart';
import 'active_parking_list_tile.dart';

class ActiveParkingItems extends StatelessWidget {
  const ActiveParkingItems({super.key});

  Future<List<Parking>> _getActiveParkings(BuildContext context) async {
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
        .findActiveParkingsForOwner(owner);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Parking>>(
      future: _getActiveParkings(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final parkings = snapshot.data!;
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
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
