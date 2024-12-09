import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

part 'available_spaces_event.dart';

part 'available_spaces_state.dart';

class AvailableSpacesBloc
    extends Bloc<AvailableSpacesEvent, AvailableSpacesState> {
  AvailableSpacesBloc() : super(AllParkingInitial()) {
    on<AllParkingLoad>(_onLoad);
    on<AllParkingUpdate>(_onUpdate);
  }

  Future<void> _onLoad(
    AllParkingLoad event,
    Emitter<AvailableSpacesState> emit,
  ) async {
    await loadAllParkings(emit);
  }

  Future<void> _onUpdate(
    AllParkingUpdate event,
    Emitter<AvailableSpacesState> emit,
  ) async {
    await loadAllParkings(emit);
  }

  Future<void> loadAllParkings(
    Emitter<AvailableSpacesState> emit,
  ) async {
    emit(AllParkingLoading());

    List<ParkingSpace> availableSpaces =
        await RemoteParkingSpaceRepository.instance.findAvailableSpaces();

    emit(AllParkingLoaded(spaces: availableSpaces));
  }
}
