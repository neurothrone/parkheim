import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

part 'available_spaces_event.dart';

part 'available_spaces_state.dart';

class AvailableSpacesBloc
    extends Bloc<AvailableSpacesEvent, AvailableSpacesState> {
  AvailableSpacesBloc({
    required RemoteParkingRepository remoteParkingRepository,
    required RemoteParkingSpaceRepository remoteParkingSpaceRepository,
  })  : _remoteParkingRepository = remoteParkingRepository,
        _remoteParkingSpaceRepository = remoteParkingSpaceRepository,
        super(AvailableSpacesInitial()) {
    on<AvailableSpacesLoad>(_onLoad);
    on<AvailableSpacesStartParking>(_onStartParking);
    on<AvailableSpacesUpdate>(_onUpdate);
  }

  final RemoteParkingRepository _remoteParkingRepository;
  final RemoteParkingSpaceRepository _remoteParkingSpaceRepository;

  Future<void> _onLoad(
    AvailableSpacesLoad event,
    Emitter<AvailableSpacesState> emit,
  ) async {
    await loadAllParkings(emit);
  }

  Future<void> _onStartParking(
    AvailableSpacesStartParking event,
    Emitter<AvailableSpacesState> emit,
  ) async {
    emit(AvailableSpacesLoading());

    final result = await _remoteParkingRepository.create(
      Parking(
        id: 0,
        vehicle: event.vehicle,
        parkingSpace: event.space,
        startTime: DateTime.now(),
        endTime: null,
      ),
    );

    result.when(
      success: (_) => add(AvailableSpacesUpdate()),
      failure: (error) => emit(AvailableSpacesFailure(message: error)),
    );
  }

  Future<void> _onUpdate(
    AvailableSpacesUpdate event,
    Emitter<AvailableSpacesState> emit,
  ) async {
    await loadAllParkings(emit);
  }

  Future<void> loadAllParkings(
    Emitter<AvailableSpacesState> emit,
  ) async {
    emit(AvailableSpacesLoading());

    try {
      List<ParkingSpace> availableSpaces =
          await _remoteParkingSpaceRepository.findAvailableSpaces();

      emit(AvailableSpacesLoaded(spaces: availableSpaces));
    } catch (_) {
      emit(AvailableSpacesFailure(message: "Unexpected error"));
    }
  }
}
