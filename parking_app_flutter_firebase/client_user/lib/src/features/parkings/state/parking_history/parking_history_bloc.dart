import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

import '../../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../../core/cubits/app_user/app_user_state.dart';

part 'parking_history_event.dart';

part 'parking_history_state.dart';

class ParkingHistoryBloc
    extends Bloc<ParkingHistoryEvent, ParkingHistoryState> {
  ParkingHistoryBloc({
    required this.appUserCubit,
    required FirebaseParkingRepository parkingRepository,
    required FirebasePersonRepository personRepository,
  })  : _parkingRepository = parkingRepository,
        _personRepository = personRepository,
        super(ParkingHistoryInitial()) {
    on<ParkingHistoryLoad>(_onLoad);
  }

  final AppUserCubit appUserCubit;
  final FirebaseParkingRepository _parkingRepository;
  final FirebasePersonRepository _personRepository;

  Future<void> _onLoad(
    ParkingHistoryLoad event,
    Emitter<ParkingHistoryState> emit,
  ) async {
    await loadParkingHistory(emit);
  }

  Future<void> loadParkingHistory(
    Emitter<ParkingHistoryState> emit,
  ) async {
    emit(ParkingHistoryLoading());

    try {
      final user = (appUserCubit.state as AppUserSignedIn).user;
      final ownerResult =
          await _personRepository.findPersonByName(user.displayName!);
      final owner = ownerResult.when(
        success: (person) => person,
        failure: (error) => null,
      );
      if (owner == null) {
        emit(ParkingHistoryFailure(message: "Owner not found"));
        return;
      }

      final results =
          await _parkingRepository.findFinishedParkingsForOwner(owner);
      emit(ParkingHistoryLoaded(parkings: results));
      // final result = await _parkingRepository.findFinishedParkingsForOwner(owner);
      // result.when(
      //   success: (parkings) => emit(ParkingHistoryLoaded(parkings: parkings)),
      //   failure: (error) => emit(ParkingHistoryFailure(message: error)),
      // );
    } catch (_) {
      emit(ParkingHistoryFailure(message: "Unexpected error"));
    }
  }
}
