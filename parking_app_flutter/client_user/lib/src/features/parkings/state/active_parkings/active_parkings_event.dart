part of 'active_parkings_bloc.dart';

sealed class ActiveParkingsEvent {
  const ActiveParkingsEvent();
}

final class ActiveParkingLoad extends ActiveParkingsEvent {}

final class ActiveParkingEnd extends ActiveParkingsEvent {
  const ActiveParkingEnd({required this.parking});

  final Parking parking;
}

final class ActiveParkingUpdate extends ActiveParkingsEvent {}
