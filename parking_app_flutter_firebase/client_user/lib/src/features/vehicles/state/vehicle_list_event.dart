part of 'vehicle_list_bloc.dart';

sealed class VehicleListEvent {
  const VehicleListEvent();
}

final class VehicleListLoad extends VehicleListEvent {}

final class VehicleListAddItem extends VehicleListEvent {
  const VehicleListAddItem({
    required this.registrationNumber,
    required this.vehicleType,
  });

  final String registrationNumber;
  final VehicleType vehicleType;
}

final class VehicleListDeleteItem extends VehicleListEvent {
  const VehicleListDeleteItem({required this.id});

  final String id;
}

final class VehicleListUpdate extends VehicleListEvent {}
