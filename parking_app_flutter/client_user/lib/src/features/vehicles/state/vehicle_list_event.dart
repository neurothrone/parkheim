part of 'vehicle_list_bloc.dart';

sealed class VehicleListEvent {
  const VehicleListEvent();
}

final class VehicleListLoad extends VehicleListEvent {}

final class VehicleListUpdate extends VehicleListEvent {}
