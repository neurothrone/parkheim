part of 'active_parkings_bloc.dart';

@immutable
abstract class ActiveParkingsState {
  const ActiveParkingsState();
}

class ActiveParkingInitial extends ActiveParkingsState {}

class ActiveParkingLoading extends ActiveParkingsState {}

class ActiveParkingLoaded extends ActiveParkingsState {
  const ActiveParkingLoaded({
    required this.parkings,
  });

  final List<Parking> parkings;
}

class ActiveParkingFailure extends ActiveParkingsState {
  const ActiveParkingFailure({
    required this.message,
  });

  final String message;
}
