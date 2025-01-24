part of 'spaces_list_bloc.dart';

sealed class SpacesListState extends Equatable {
  const SpacesListState();
}

class SpacesListInitial extends SpacesListState {
  @override
  List<Object?> get props => [];
}

class SpacesListLoading extends SpacesListState {
  @override
  List<Object?> get props => [];
}

class SpacesListLoaded extends SpacesListState {
  const SpacesListLoaded({
    required this.spaces,
  });

  final List<ParkingSpace> spaces;

  @override
  List<Object?> get props => [spaces];
}

class SpacesListFailure extends SpacesListState {
  const SpacesListFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
