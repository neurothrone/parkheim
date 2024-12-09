import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../../core/cubits/app_user/app_user_state.dart';

part 'active_parkings_event.dart';

part 'active_parkings_state.dart';

class ActiveParkingsBloc extends Bloc<ActiveParkingsEvent, ActiveParkingsState> {
  ActiveParkingsBloc({
    required this.appUserCubit,
  }) : super(ActiveParkingInitial()) {
    on<ActiveParkingLoad>(_onLoad);
    on<ActiveParkingUpdate>(_onUpdate);
  }

  final AppUserCubit appUserCubit;

  Future<void> _onLoad(
    ActiveParkingLoad event,
    Emitter<ActiveParkingsState> emit,
  ) async {
    await loadActiveParkings(emit);
  }

  Future<void> _onUpdate(
    ActiveParkingUpdate event,
    Emitter<ActiveParkingsState> emit,
  ) async {
    await loadActiveParkings(emit);
  }

  Future<void> loadActiveParkings(
    Emitter<ActiveParkingsState> emit,
  ) async {
    emit(ActiveParkingLoading());

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
      emit(ActiveParkingFailure(message: "Owner not found"));
      return;
    }

    final parkings = await RemoteParkingRepository.instance
        .findActiveParkingsForOwner(owner);
    emit(ActiveParkingLoaded(parkings: parkings));
  }
}
