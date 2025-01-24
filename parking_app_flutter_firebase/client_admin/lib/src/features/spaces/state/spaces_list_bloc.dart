import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

part 'spaces_list_event.dart';

part 'spaces_list_state.dart';

class SpacesListBloc extends Bloc<SpacesListEvent, SpacesListState> {
  SpacesListBloc({
    required FirebaseParkingSpaceRepository parkingSpaceRepository,
  })  : _parkingSpaceRepository = parkingSpaceRepository,
        super(SpacesListInitial()) {
    on<SpacesListLoad>(_onLoad);
    on<SpacesListAddItem>(_onAdd);
    on<SpacesListUpdate>(_onUpdate);
    on<SpacesListDeleteItem>(_onDelete);
  }

  final FirebaseParkingSpaceRepository _parkingSpaceRepository;

  Future<void> loadAllSpaces(
    Emitter<SpacesListState> emit,
  ) async {
    emit(SpacesListLoading());

    try {
      final result = await _parkingSpaceRepository.getAll();
      result.when(
        success: (spaces) => emit(SpacesListLoaded(spaces: spaces)),
        failure: (error) => emit(SpacesListFailure(message: error)),
      );
    } catch (_) {
      emit(SpacesListFailure(message: "Unexpected error"));
    }
  }

  Future<void> _onLoad(
    SpacesListLoad event,
    Emitter<SpacesListState> emit,
  ) async {
    await loadAllSpaces(emit);
  }

  Future<void> _onAdd(
    SpacesListAddItem event,
    Emitter<SpacesListState> emit,
  ) async {
    emit(SpacesListLoading());

    final result = await _parkingSpaceRepository.create(event.space);
    result.when(
      success: (_) => add(SpacesListUpdate()),
      failure: (error) => emit(SpacesListFailure(message: error)),
    );
  }

  Future<void> _onUpdate(
    SpacesListUpdate event,
    Emitter<SpacesListState> emit,
  ) async {
    await loadAllSpaces(emit);
  }

  Future<void> _onDelete(
    SpacesListDeleteItem event,
    Emitter<SpacesListState> emit,
  ) async {
    emit(SpacesListLoading());

    final result = await _parkingSpaceRepository.delete(event.id);
    result.when(
      success: (_) => add(SpacesListUpdate()),
      failure: (error) => emit(SpacesListFailure(message: error)),
    );
  }
}
