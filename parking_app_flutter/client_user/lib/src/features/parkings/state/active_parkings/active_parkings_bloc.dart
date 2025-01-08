import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../../core/cubits/app_user/app_user_state.dart';

part 'active_parkings_event.dart';

part 'active_parkings_state.dart';

class ActiveParkingsBloc
    extends Bloc<ActiveParkingsEvent, ActiveParkingsState> {
  ActiveParkingsBloc({
    required this.appUserCubit,
    required RemotePersonRepository remotePersonRepository,
    required RemoteParkingRepository remoteParkingRepository,
  })  : _remotePersonRepository = remotePersonRepository,
        _remoteParkingRepository = remoteParkingRepository,
        super(ActiveParkingInitial()) {
    on<ActiveParkingLoad>(_onLoad);
    on<ActiveParkingUpdate>(_onUpdate);
  }

  final AppUserCubit appUserCubit;
  final RemotePersonRepository _remotePersonRepository;
  final RemoteParkingRepository _remoteParkingRepository;

  Future<void> _onLoad(
    ActiveParkingLoad event,
    Emitter<ActiveParkingsState> emit,
  ) async {
    await loadActiveParkings(emit);
  }

  Future<void> _onUpdate(
    ActiveParkingUpdate event,
    Emitter<ActiveParkingsState> emit,
  ) async {
    await loadActiveParkings(emit);
  }

  Future<void> loadActiveParkings(
    Emitter<ActiveParkingsState> emit,
  ) async {
    emit(ActiveParkingLoading());

    final user = (appUserCubit.state as AppUserSignedIn).user;

    final ownerResult =
        await _remotePersonRepository.findPersonByName(user.displayName!);
    final owner = ownerResult.when(
      success: (person) => person,
      failure: (error) => null,
    );
    if (owner == null) {
      emit(ActiveParkingFailure(message: "Owner not found"));
      return;
    }

    final parkings =
        await _remoteParkingRepository.findActiveParkingsForOwner(owner);
    emit(ActiveParkingLoaded(parkings: parkings));
  }

  Future<Result<void, String>> endParking(Parking parking) async {
    final result = await RemoteParkingRepository.instance.endParking(parking);
    return result.when(
      success: (_) {
        add(ActiveParkingUpdate());
        return Result.success(value: null);
      },
      failure: (error) => Result.failure(error: error),
    );
  }
}
