import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../core/cubits/app_user/app_user_state.dart';

part 'vehicle_list_event.dart';

part 'vehicle_list_state.dart';

class VehicleListBloc extends Bloc<VehicleListEvent, VehicleListState> {
  VehicleListBloc({
    required this.appUserCubit,
  }) : super(VehicleListInitial()) {
    on<VehicleListLoad>(_onLoad);
    on<VehicleListUpdate>(_onUpdate);
  }

  final AppUserCubit appUserCubit;

  Future<void> _onLoad(
    VehicleListLoad event,
    Emitter<VehicleListState> emit,
  ) async {
    await loadOwnedVehicles(emit);
  }

  Future<void> _onUpdate(
    VehicleListUpdate event,
    Emitter<VehicleListState> emit,
  ) async {
    await loadOwnedVehicles(emit);
  }

  Future<void> loadOwnedVehicles(
    Emitter<VehicleListState> emit,
  ) async {
    emit(VehicleListLoading());

    final user = (appUserCubit.state as AppUserSignedIn).user;

    final ownerResult = await RemotePersonRepository.instance
        .findPersonByName(user.displayName!);
    final owner = ownerResult.when(
      success: (person) => person,
      failure: (error) {
        return null;
      },
    );
    if (owner == null) {
      emit(VehicleListFailure(message: "Owner not found"));
      return;
    }

    final result =
        await RemoteVehicleRepository.instance.findVehiclesByOwner(owner);

    result.when(
      success: (List<Vehicle> vehicles) => emit(
        VehicleListLoaded(vehicles: vehicles),
      ),
      failure: (error) => emit(VehicleListFailure(message: error)),
    );
  }
}
