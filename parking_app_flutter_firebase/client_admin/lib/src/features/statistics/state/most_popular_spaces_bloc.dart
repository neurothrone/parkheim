import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

class MostPopularSpacesBloc
    extends Bloc<MostPopularSpacesEvent, MostPopularSpacesState> {
  MostPopularSpacesBloc({
    required FirebaseParkingRepository parkingRepository,
  })  : _parkingRepository = parkingRepository,
        super(MostPopularSpacesInitial()) {
    on<MostPopularSpacesLoad>(_onLoad);
  }

  final FirebaseParkingRepository _parkingRepository;

  Future<void> _onLoad(
    MostPopularSpacesLoad event,
    Emitter<MostPopularSpacesState> emit,
  ) async {
    emit(MostPopularSpacesLoading());

    try {
      final spaces = await _parkingRepository.getMostPopularParkingSpaces(
        limit: 3,
      );
      emit(MostPopularSpacesLoaded(spaces: spaces));
    } catch (_) {
      emit(MostPopularSpacesLoadFailure(message: "Unexpected error"));
    }
  }
}

sealed class MostPopularSpacesEvent {
  const MostPopularSpacesEvent();
}

class MostPopularSpacesLoad extends MostPopularSpacesEvent {}

sealed class MostPopularSpacesState extends Equatable {
  const MostPopularSpacesState();
}

class MostPopularSpacesInitial extends MostPopularSpacesState {
  @override
  List<Object?> get props => [];
}

class MostPopularSpacesLoading extends MostPopularSpacesState {
  @override
  List<Object?> get props => [];
}

class MostPopularSpacesLoaded extends MostPopularSpacesState {
  const MostPopularSpacesLoaded({required this.spaces});

  final List<ParkingSpace> spaces;

  @override
  List<Object?> get props => [spaces];
}

class MostPopularSpacesLoadFailure extends MostPopularSpacesState {
  const MostPopularSpacesLoadFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
