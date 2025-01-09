import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

part 'parking_list_event.dart';

part 'parking_list_state.dart';

class ParkingListBloc extends Bloc<ParkingListEvent, ParkingListState> {
  ParkingListBloc({
    required RemoteParkingRepository remoteParkingRepository,
  })  : _remoteParkingRepository = remoteParkingRepository,
        super(ParkingListInitial()) {
    on<ParkingListLoadActiveItems>(_onLoadActiveItems);
    on<ParkingListLoadAllItems>(_onLoadAllItems);
    on<ParkingListSearchInitial>(_onSearchInitial);
    on<ParkingListSearchItems>(_onSearchItems);
  }

  final RemoteParkingRepository _remoteParkingRepository;

  Future<void> _onLoadActiveItems(
    ParkingListLoadActiveItems event,
    Emitter<ParkingListState> emit,
  ) async {
    emit(ParkingListLoading());

    try {
      final result = await _remoteParkingRepository.findActiveParkings();
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
          await _remoteParkingRepository.findAllParkingsSortedByStartTime();
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
          await _remoteParkingRepository.searchParkings(event.searchText);
      result.when(
        success: (parkings) => emit(ParkingListLoaded(parkings: parkings)),
        failure: (error) => emit(ParkingListFailure(message: error)),
      );
    } catch (_) {
      emit(ParkingListFailure(message: "Unexpected error"));
    }
  }
}
