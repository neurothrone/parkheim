part of 'available_spaces_bloc.dart';

sealed class AvailableSpacesEvent {
  const AvailableSpacesEvent();
}

final class AllParkingLoad extends AvailableSpacesEvent {}

final class AllParkingUpdate extends AvailableSpacesEvent {}
