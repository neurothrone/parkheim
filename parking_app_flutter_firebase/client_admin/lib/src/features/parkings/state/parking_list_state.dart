part of 'parking_list_bloc.dart';

sealed class ParkingListState extends Equatable {
  const ParkingListState();
}

class ParkingListInitial extends ParkingListState {
  @override
  List<Object?> get props => [];
}

class ParkingListLoading extends ParkingListState {
  @override
  List<Object?> get props => [];
}

class ParkingListLoaded extends ParkingListState {
  const ParkingListLoaded({
    required this.parkings,
  });

  final List<Parking> parkings;

  @override
  List<Object?> get props => [parkings];
}

class ParkingListFailure extends ParkingListState {
  const ParkingListFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
