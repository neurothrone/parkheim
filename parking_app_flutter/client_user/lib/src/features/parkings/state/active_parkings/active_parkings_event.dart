part of 'active_parkings_bloc.dart';

sealed class ActiveParkingsEvent {
  const ActiveParkingsEvent();
}

final class ActiveParkingLoad extends ActiveParkingsEvent {}

final class ActiveParkingUpdate extends ActiveParkingsEvent {}
