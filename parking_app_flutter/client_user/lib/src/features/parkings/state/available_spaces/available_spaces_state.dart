part of 'available_spaces_bloc.dart';

sealed class AvailableSpacesState extends Equatable {
  const AvailableSpacesState();
}

class AvailableSpacesInitial extends AvailableSpacesState {
  @override
  List<Object?> get props => [];
}

class AvailableSpacesLoading extends AvailableSpacesState {
  @override
  List<Object?> get props => [];
}

class AvailableSpacesLoaded extends AvailableSpacesState {
  const AvailableSpacesLoaded({
    required this.spaces,
  });

  final List<ParkingSpace> spaces;

  @override
  List<Object?> get props => [spaces];
}

class AvailableSpacesFailure extends AvailableSpacesState {
  const AvailableSpacesFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
