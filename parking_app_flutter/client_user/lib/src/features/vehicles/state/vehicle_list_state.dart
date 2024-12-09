part of 'vehicle_list_bloc.dart';

@immutable
abstract class VehicleListState {
  const VehicleListState();
}

class VehicleListInitial extends VehicleListState {}

class VehicleListLoading extends VehicleListState {}

class VehicleListLoaded extends VehicleListState {
  const VehicleListLoaded({
    required this.vehicles,
  });

  final List<Vehicle> vehicles;
}

class VehicleListFailure extends VehicleListState {
  const VehicleListFailure({
    required this.message,
  });

  final String message;
}
