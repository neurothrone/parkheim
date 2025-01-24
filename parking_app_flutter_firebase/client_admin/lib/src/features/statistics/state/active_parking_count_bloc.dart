import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_client_firebase/shared_client_firebase.dart';

class ActiveParkingCountBloc
    extends Bloc<ActiveParkingCountEvent, ActiveParkingCountState> {
  ActiveParkingCountBloc({
    required FirebaseParkingRepository parkingRepository,
  })  : _parkingRepository = parkingRepository,
        super(ActiveParkingCountInitial()) {
    on<ActiveParkingCountLoad>(_onLoad);
  }

  final FirebaseParkingRepository _parkingRepository;

  Future<void> _onLoad(
    ActiveParkingCountLoad event,
    Emitter<ActiveParkingCountState> emit,
  ) async {
    emit(ActiveParkingCountLoading());

    try {
      final count = await _parkingRepository.getActiveParkingsCount();
      emit(ActiveParkingCountLoaded(activeParkingCount: count));
    } catch (_) {
      emit(ActiveParkingCountFailure(message: "Unexpected error"));
    }
  }
}

sealed class ActiveParkingCountEvent {
  const ActiveParkingCountEvent();
}

class ActiveParkingCountLoad extends ActiveParkingCountEvent {}

sealed class ActiveParkingCountState extends Equatable {
  const ActiveParkingCountState();
}

class ActiveParkingCountInitial extends ActiveParkingCountState {
  @override
  List<Object?> get props => [];
}

class ActiveParkingCountLoading extends ActiveParkingCountState {
  @override
  List<Object?> get props => [];
}

class ActiveParkingCountLoaded extends ActiveParkingCountState {
  const ActiveParkingCountLoaded({required this.activeParkingCount});

  final int activeParkingCount;

  @override
  List<Object?> get props => [activeParkingCount];
}

class ActiveParkingCountFailure extends ActiveParkingCountState {
  const ActiveParkingCountFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
