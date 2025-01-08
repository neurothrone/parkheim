import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../core/cubits/app_user/app_user_state.dart';

part 'vehicle_list_event.dart';

part 'vehicle_list_state.dart';

class VehicleListBloc extends Bloc<VehicleListEvent, VehicleListState> {
  VehicleListBloc({
    required this.appUserCubit,
    required RemotePersonRepository remotePersonRepository,
    required RemoteVehicleRepository remoteVehicleRepository,
  })  : _remotePersonRepository = remotePersonRepository,
        _remoteVehicleRepository = remoteVehicleRepository,
        super(VehicleListInitial()) {
    on<VehicleListLoad>(_onLoad);
    on<VehicleListUpdate>(_onUpdate);
  }

  final AppUserCubit appUserCubit;
  final RemotePersonRepository _remotePersonRepository;
  final RemoteVehicleRepository _remoteVehicleRepository;

  Future<void> _onLoad(
    VehicleListLoad event,
    Emitter<VehicleListState> emit,
  ) async {
    await loadOwnedVehicles(emit);
  }

  Future<void> _onUpdate(
    VehicleListUpdate event,
    Emitter<VehicleListState> emit,
  ) async {
    await loadOwnedVehicles(emit);
  }

  Future<void> loadOwnedVehicles(
    Emitter<VehicleListState> emit,
  ) async {
    emit(VehicleListLoading());

    final user = (appUserCubit.state as AppUserSignedIn).user;

    final ownerResult =
        await _remotePersonRepository.findPersonByName(user.displayName!);
    final owner = ownerResult.when(
      success: (person) => person,
      failure: (error) => null,
    );
    if (owner == null) {
      emit(VehicleListFailure(message: "Owner not found"));
      return;
    }

    final result = await _remoteVehicleRepository.findVehiclesByOwner(owner);

    result.when(
      success: (List<Vehicle> vehicles) => emit(
        VehicleListLoaded(vehicles: vehicles),
      ),
      failure: (error) => emit(VehicleListFailure(message: error)),
    );
  }

  Future<Result<void, String>> addVehicle({
    required String registrationNumber,
    required VehicleType vehicleType,
  }) async {
    final user = (appUserCubit.state as AppUserSignedIn).user;
    final ownerResult =
        await _remotePersonRepository.findPersonByName(user.displayName!);
    final owner = ownerResult.when(
      success: (person) => person,
      failure: (error) => null,
    );
    if (owner == null) {
      return Result.failure(error: "Owner not found");
    }

    final result = await _remoteVehicleRepository.create(
      Vehicle(
        id: 0,
        registrationNumber: registrationNumber,
        vehicleType: vehicleType,
        owner: owner,
      ),
    );
    return result.when(
      success: (_) {
        add(VehicleListUpdate());
        return Result.success(value: null);
      },
      failure: (error) => Result.failure(error: error),
    );
  }

  Future<Result<void, String>> deleteVehicle({
    required int vehicleId,
  }) async {
    final result = await RemoteVehicleRepository.instance.delete(vehicleId);
    return result.when(
      success: (_) {
        add(VehicleListUpdate());
        return Result.success(value: null);
      },
      failure: (error) => Result.failure(error: error),
    );
  }

  Future<Result<List<Vehicle>, String>> getVehiclesForOwner() async {
    final user = (appUserCubit.state as AppUserSignedIn).user;
    final ownerResult =
        await _remotePersonRepository.findPersonByName(user.displayName!);
    final owner = ownerResult.when(
      success: (person) => person,
      failure: (error) => null,
    );
    if (owner == null) {
      return Result.failure(error: "Owner not found");
    }

    final result = await _remoteVehicleRepository.findVehiclesByOwner(owner);
    return result;
  }
}
