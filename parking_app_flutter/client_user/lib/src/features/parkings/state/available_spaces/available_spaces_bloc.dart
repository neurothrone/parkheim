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
        super(AllParkingInitial()) {
    on<AllParkingLoad>(_onLoad);
    on<AllParkingUpdate>(_onUpdate);
  }

  final RemoteParkingRepository _remoteParkingRepository;
  final RemoteParkingSpaceRepository _remoteParkingSpaceRepository;

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

    try {
      List<ParkingSpace> availableSpaces =
          await _remoteParkingSpaceRepository.findAvailableSpaces();

      emit(AllParkingLoaded(spaces: availableSpaces));
    } catch (_) {
      emit(AllParkingFailure(message: "Unexpected error"));
    }
  }

  Future<Result<void, String>> startParking({
    required ParkingSpace space,
    required Vehicle vehicle,
  }) async {
    final result = await _remoteParkingRepository.create(
      Parking(
        id: 0,
        vehicle: vehicle,
        parkingSpace: space,
        startTime: DateTime.now(),
        endTime: null,
      ),
    );

    return result.when(
      success: (_) {
        add(AllParkingUpdate());
        return Result.success(value: null);
      },
      failure: (error) => Result.failure(error: error),
    );
  }
}
