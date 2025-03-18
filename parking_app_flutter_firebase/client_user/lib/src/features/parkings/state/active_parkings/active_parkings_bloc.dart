import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

import '../../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../../core/cubits/app_user/app_user_state.dart';
import '../../../../data/repositories/notification_repository.dart';

part 'active_parkings_event.dart';

part 'active_parkings_state.dart';

class ActiveParkingsBloc
    extends Bloc<ActiveParkingsEvent, ActiveParkingsState> {
  ActiveParkingsBloc({
    required this.appUserCubit,
    required FirebasePersonRepository personRepository,
    required FirebaseParkingRepository parkingRepository,
    required NotificationRepository notificationRepository,
  })  : _personRepository = personRepository,
        _parkingRepository = parkingRepository,
        _notificationRepository = notificationRepository,
        super(ActiveParkingsInitial()) {
    on<ActiveParkingLoad>(_onLoad);
    on<ActiveParkingExtend>(_onExtend);
    on<ActiveParkingEnd>(_onEnd);
    on<ActiveParkingUpdate>(_onUpdate);
  }

  final AppUserCubit appUserCubit;
  final FirebasePersonRepository _personRepository;
  final FirebaseParkingRepository _parkingRepository;
  final NotificationRepository _notificationRepository;

  Future<void> _onLoad(
    ActiveParkingLoad event,
    Emitter<ActiveParkingsState> emit,
  ) async {
    await loadActiveParkings(emit);
  }

  Future<void> _onExtend(
    ActiveParkingExtend event,
    Emitter<ActiveParkingsState> emit,
  ) async {
    emit(ActiveParkingsLoading());

    final result = await _parkingRepository.extendParking(event.parking);
    return result.when(
      success: (parking) {
        emit(ActiveParkingExtended());
        add(ActiveParkingUpdate());

        _notificationRepository.rescheduleParkingReminder(
          parking.id.hashCode,
          parking.endTime,
        );
      },
      failure: (error) => emit(ActiveParkingsFailure(message: error)),
    );
  }

  Future<void> _onEnd(
    ActiveParkingEnd event,
    Emitter<ActiveParkingsState> emit,
  ) async {
    emit(ActiveParkingsLoading());

    final result = await _parkingRepository.endParking(event.parking);
    return result.when(
      success: (parking) {
        emit(ActiveParkingEnded());
        add(ActiveParkingUpdate());

        _notificationRepository.cancelParkingReminder(parking.id.hashCode);
      },
      failure: (error) => emit(ActiveParkingsFailure(message: error)),
    );
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
    emit(ActiveParkingsLoading());

    final user = (appUserCubit.state as AppUserSignedIn).user;
    final ownerResult =
        await _personRepository.findPersonByName(user.displayName!);
    final owner = ownerResult.when(
      success: (person) => person,
      failure: (error) => null,
    );
    if (owner == null) {
      emit(ActiveParkingsFailure(message: "Owner not found"));
      return;
    }

    final result = await _parkingRepository.findActiveParkingsForOwner(owner);
    result.when(
      success: (parkings) => emit(ActiveParkingsLoaded(parkings: parkings)),
      failure: (error) => emit(ActiveParkingsFailure(message: error)),
    );
  }
}
