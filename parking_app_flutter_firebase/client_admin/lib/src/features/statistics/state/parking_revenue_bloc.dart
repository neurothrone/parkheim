import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_client_firebase/shared_client_firebase.dart';

class ParkingRevenueBloc
    extends Bloc<ParkingRevenueEvent, ParkingRevenueState> {
  ParkingRevenueBloc({
    required FirebaseParkingRepository parkingRepository,
  })  : _parkingRepository = parkingRepository,
        super(ParkingRevenueInitial()) {
    on<ParkingRevenueLoad>(_onLoad);
  }

  final FirebaseParkingRepository _parkingRepository;

  Future<void> _onLoad(
    ParkingRevenueLoad event,
    Emitter<ParkingRevenueState> emit,
  ) async {
    emit(ParkingRevenueLoading());

    try {
      final revenue = await _parkingRepository.getTotalRevenueFromParkings();
      emit(ParkingRevenueLoaded(revenue: revenue));
    } catch (_) {
      emit(ParkingRevenueFailure(message: "Unexpected error"));
    }
  }
}

sealed class ParkingRevenueEvent {
  const ParkingRevenueEvent();
}

class ParkingRevenueLoad extends ParkingRevenueEvent {}

sealed class ParkingRevenueState extends Equatable {
  const ParkingRevenueState();
}

class ParkingRevenueInitial extends ParkingRevenueState {
  @override
  List<Object?> get props => [];
}

class ParkingRevenueLoading extends ParkingRevenueState {
  @override
  List<Object?> get props => [];
}

class ParkingRevenueLoaded extends ParkingRevenueState {
  const ParkingRevenueLoaded({required this.revenue});

  final double revenue;

  @override
  List<Object?> get props => [revenue];
}

class ParkingRevenueFailure extends ParkingRevenueState {
  const ParkingRevenueFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
