import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

part 'available_spaces_event.dart';

part 'available_spaces_state.dart';

class AvailableSpacesBloc
    extends Bloc<AvailableSpacesEvent, AvailableSpacesState> {
  AvailableSpacesBloc({
    required FirebaseParkingRepository parkingRepository,
    required FirebaseParkingSpaceRepository parkingSpaceRepository,
  })  : _parkingRepository = parkingRepository,
        _parkingSpaceRepository = parkingSpaceRepository,
        super(AvailableSpacesInitial()) {
    on<AvailableSpacesLoad>(_onLoad);
    on<AvailableSpacesStartParking>(_onStartParking);
    on<AvailableSpacesUpdate>(_onUpdate);
  }

  final FirebaseParkingRepository _parkingRepository;
  final FirebaseParkingSpaceRepository _parkingSpaceRepository;

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

    final result = await _parkingRepository.create(
      Parking(
        id: null,
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
          await _parkingSpaceRepository.findAvailableSpaces();

      emit(AvailableSpacesLoaded(spaces: availableSpaces));
    } catch (_) {
      emit(AvailableSpacesFailure(message: "Unexpected error"));
    }
  }
}
