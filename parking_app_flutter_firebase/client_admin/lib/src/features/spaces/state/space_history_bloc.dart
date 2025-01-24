import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

part 'space_history_event.dart';

part 'space_history_state.dart';

class SpaceHistoryBloc extends Bloc<SpaceHistoryEvent, SpaceHistoryState> {
  SpaceHistoryBloc({
    required FirebaseParkingRepository parkingRepository,
  })  : _parkingRepository = parkingRepository,
        super(SpaceHistoryInitial()) {
    on<SpaceHistoryLoad>(_onLoad);
  }

  final FirebaseParkingRepository _parkingRepository;

  Future<void> _onLoad(
    SpaceHistoryLoad event,
    Emitter<SpaceHistoryState> emit,
  ) async {
    emit(SpaceHistoryLoading());

    try {
      final parkings = await _parkingRepository.getHistoryForParkingSpace(
        event.space,
      );
      emit(SpaceHistoryLoaded(parkings: parkings));
    } catch (_) {
      emit(SpaceHistoryFailure(message: "Unexpected error"));
    }
  }
}
