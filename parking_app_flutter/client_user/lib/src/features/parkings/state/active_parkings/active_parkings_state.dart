part of 'active_parkings_bloc.dart';

sealed class ActiveParkingsState extends Equatable {
  const ActiveParkingsState();
}

class ActiveParkingInitial extends ActiveParkingsState {
  @override
  List<Object?> get props => [];
}

class ActiveParkingLoading extends ActiveParkingsState {
  @override
  List<Object?> get props => [];
}

class ActiveParkingLoaded extends ActiveParkingsState {
  const ActiveParkingLoaded({
    required this.parkings,
  });

  final List<Parking> parkings;

  @override
  List<Object?> get props => [parkings];
}

class ActiveParkingFailure extends ActiveParkingsState {
  const ActiveParkingFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
