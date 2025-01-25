part of 'parking_history_bloc.dart';

sealed class ParkingHistoryState extends Equatable {
  const ParkingHistoryState();
}

final class ParkingHistoryInitial extends ParkingHistoryState {
  @override
  List<Object?> get props => [];
}

final class ParkingHistoryLoading extends ParkingHistoryState {
  @override
  List<Object?> get props => [];
}

final class ParkingHistoryLoaded extends ParkingHistoryState {
  const ParkingHistoryLoaded({required this.parkings});

  final List<Parking> parkings;

  @override
  List<Object?> get props => [parkings];
}

final class ParkingHistoryFailure extends ParkingHistoryState {
  const ParkingHistoryFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
