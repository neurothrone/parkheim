part of 'active_parkings_bloc.dart';

sealed class ActiveParkingsState extends Equatable {
  const ActiveParkingsState();
}

class ActiveParkingsInitial extends ActiveParkingsState {
  @override
  List<Object?> get props => [];
}

class ActiveParkingsLoading extends ActiveParkingsState {
  @override
  List<Object?> get props => [];
}

class ActiveParkingsLoaded extends ActiveParkingsState {
  const ActiveParkingsLoaded({
    required this.parkings,
  });

  final List<Parking> parkings;

  @override
  List<Object?> get props => [parkings];
}

class ActiveParkingExtended extends ActiveParkingsState {
  @override
  List<Object?> get props => [];
}

class ActiveParkingEnded extends ActiveParkingsState {
  @override
  List<Object?> get props => [];
}

class ActiveParkingsFailure extends ActiveParkingsState {
  const ActiveParkingsFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
