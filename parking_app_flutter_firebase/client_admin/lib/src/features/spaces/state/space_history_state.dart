part of 'space_history_bloc.dart';

sealed class SpaceHistoryState extends Equatable {
  const SpaceHistoryState();
}

class SpaceHistoryInitial extends SpaceHistoryState {
  @override
  List<Object?> get props => [];
}

class SpaceHistoryLoading extends SpaceHistoryState {
  @override
  List<Object?> get props => [];
}

class SpaceHistoryLoaded extends SpaceHistoryState {
  const SpaceHistoryLoaded({required this.parkings});

  final List<Parking> parkings;

  @override
  List<Object?> get props => [parkings];
}

class SpaceHistoryFailure extends SpaceHistoryState {
  const SpaceHistoryFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}