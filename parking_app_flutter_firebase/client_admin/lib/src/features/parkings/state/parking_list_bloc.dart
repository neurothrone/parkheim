import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

part 'parking_list_event.dart';

part 'parking_list_state.dart';

class ParkingListBloc extends Bloc<ParkingListEvent, ParkingListState> {
  ParkingListBloc({
    required FirebaseParkingRepository parkingRepository,
  })  : _parkingRepository = parkingRepository,
        super(ParkingListInitial()) {
    on<ParkingListLoadActiveItems>(_onLoadActiveItems);
    on<ParkingListLoadAllItems>(_onLoadAllItems);
    on<ParkingListSearchInitial>(_onSearchInitial);
    on<ParkingListSearchItems>(_onSearchItems);
  }

  final FirebaseParkingRepository _parkingRepository;

  Future<void> _onLoadActiveItems(
    ParkingListLoadActiveItems event,
    Emitter<ParkingListState> emit,
  ) async {
    emit(ParkingListLoading());

    try {
      final result = await _parkingRepository.findActiveParkings();
      result.when(
        success: (parkings) => emit(ParkingListLoaded(parkings: parkings)),
        failure: (error) => emit(ParkingListFailure(message: error)),
      );
    } catch (_) {
      emit(ParkingListFailure(message: "Unexpected error"));
    }
  }

  Future<void> _onLoadAllItems(
    ParkingListLoadAllItems event,
    Emitter<ParkingListState> emit,
  ) async {
    emit(ParkingListLoading());

    try {
      final result =
          await _parkingRepository.findAllParkingsSortedByStartTime();
      result.when(
        success: (parkings) => emit(ParkingListLoaded(parkings: parkings)),
        failure: (error) => emit(ParkingListFailure(message: error)),
      );
    } catch (_) {
      emit(ParkingListFailure(message: "Unexpected error"));
    }
  }

  Future<void> _onSearchInitial(
    ParkingListSearchInitial event,
    Emitter<ParkingListState> emit,
  ) async {
    emit(ParkingListLoaded(parkings: []));
  }

  Future<void> _onSearchItems(
    ParkingListSearchItems event,
    Emitter<ParkingListState> emit,
  ) async {
    emit(ParkingListLoading());

    try {
      final result =
          await _parkingRepository.searchParkings(event.searchText);
      result.when(
        success: (parkings) => emit(ParkingListLoaded(parkings: parkings)),
        failure: (error) => emit(ParkingListFailure(message: error)),
      );
    } catch (_) {
      emit(ParkingListFailure(message: "Unexpected error"));
    }
  }
}
