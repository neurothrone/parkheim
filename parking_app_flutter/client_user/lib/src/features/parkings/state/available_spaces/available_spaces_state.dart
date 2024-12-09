part of 'available_spaces_bloc.dart';

@immutable
abstract class AvailableSpacesState {
  const AvailableSpacesState();
}

class AllParkingInitial extends AvailableSpacesState {}

class AllParkingLoading extends AvailableSpacesState {}

class AllParkingLoaded extends AvailableSpacesState {
  const AllParkingLoaded({
    required this.spaces,
  });

  final List<ParkingSpace> spaces;
}

class AllParkingFailure extends AvailableSpacesState {
  const AllParkingFailure({
    required this.message,
  });

  final String message;
}
