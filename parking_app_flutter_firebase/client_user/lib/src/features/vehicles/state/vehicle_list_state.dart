part of 'vehicle_list_bloc.dart';

sealed class VehicleListState extends Equatable {
  const VehicleListState();
}

class VehicleListInitial extends VehicleListState {
  @override
  List<Object?> get props => [];
}

class VehicleListLoading extends VehicleListState {
  @override
  List<Object?> get props => [];
}

class VehicleListLoaded extends VehicleListState {
  const VehicleListLoaded({
    required this.vehicles,
  });

  final List<Vehicle> vehicles;

  @override
  List<Object?> get props => [vehicles];
}

class VehicleListEmpty extends VehicleListState {
  @override
  List<Object?> get props => [];
}

class VehicleListAdded extends VehicleListState {
  @override
  List<Object?> get props => [];
}

class VehicleListDeleted extends VehicleListState {
  @override
  List<Object?> get props => [];
}

class VehicleListFailure extends VehicleListState {
  const VehicleListFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
