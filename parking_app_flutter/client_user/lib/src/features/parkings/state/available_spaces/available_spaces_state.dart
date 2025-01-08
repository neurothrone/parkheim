part of 'available_spaces_bloc.dart';

sealed class AvailableSpacesState extends Equatable {
  const AvailableSpacesState();
}

class AllParkingInitial extends AvailableSpacesState {
  @override
  List<Object?> get props => [];
}

class AllParkingLoading extends AvailableSpacesState {
  @override
  List<Object?> get props => [];
}

class AllParkingLoaded extends AvailableSpacesState {
  const AllParkingLoaded({
    required this.spaces,
  });

  final List<ParkingSpace> spaces;

  @override
  List<Object?> get props => [spaces];
}

class AllParkingFailure extends AvailableSpacesState {
  const AllParkingFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
