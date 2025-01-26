part of 'available_spaces_bloc.dart';

sealed class AvailableSpacesEvent {
  const AvailableSpacesEvent();
}

final class SubscribeToAvailableSpaces extends AvailableSpacesEvent {}

final class AvailableSpacesLoad extends AvailableSpacesEvent {}

final class AvailableSpacesStartParking extends AvailableSpacesEvent {
  const AvailableSpacesStartParking({
    required this.space,
    required this.vehicle,
  });

  final ParkingSpace space;
  final Vehicle vehicle;
}

final class AvailableSpacesUpdate extends AvailableSpacesEvent {}
