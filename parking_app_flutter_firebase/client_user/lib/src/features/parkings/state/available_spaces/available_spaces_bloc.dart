import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

import '../../../../data/repositories/notification_repository.dart';

part 'available_spaces_event.dart';

part 'available_spaces_state.dart';

class AvailableSpacesBloc
    extends Bloc<AvailableSpacesEvent, AvailableSpacesState> {
  AvailableSpacesBloc({
    required FirebaseParkingRepository parkingRepository,
    required FirebaseParkingSpaceRepository parkingSpaceRepository,
    required NotificationRepository notificationRepository,
  })  : _parkingRepository = parkingRepository,
        _parkingSpaceRepository = parkingSpaceRepository,
        _notificationRepository = notificationRepository,
        super(AvailableSpacesInitial()) {
    on<SubscribeToAvailableSpaces>(_onSubscribeToAvailableSpaces);
    on<AvailableSpacesLoad>(_onLoad);
    on<AvailableSpacesStartParking>(_onStartParking);
    on<AvailableSpacesUpdate>(_onUpdate);
  }

  final FirebaseParkingRepository _parkingRepository;
  final FirebaseParkingSpaceRepository _parkingSpaceRepository;
  final NotificationRepository _notificationRepository;

  Future<void> _onSubscribeToAvailableSpaces(
    SubscribeToAvailableSpaces event,
    Emitter<AvailableSpacesState> emit,
  ) async {
    emit(AvailableSpacesLoading());

    await emit.onEach<List<ParkingSpace>>(
      _parkingSpaceRepository.getAvailableSpacesStream(),
      onData: (spaces) => emit(AvailableSpacesLoaded(spaces: spaces)),
      onError: (error, stackTrace) => emit(
        AvailableSpacesFailure(message: error.toString()),
      ),
    );
  }

  Future<void> _onLoad(
    AvailableSpacesLoad event,
    Emitter<AvailableSpacesState> emit,
  ) async {
    await loadAllParkings(emit);
  }

  Future<void> _onStartParking(
    AvailableSpacesStartParking event,
    Emitter<AvailableSpacesState> emit,
  ) async {
    emit(AvailableSpacesLoading());

    final startTime = DateTime.now();
    // TODO: Set endTime to 1 hour from now
    // final endTime = startTime.add(const Duration(hours: 1));
    final endTime = startTime.add(const Duration(seconds: 20));
    final result = await _parkingRepository.create(
      Parking(
        id: null,
        vehicle: event.vehicle,
        parkingSpace: event.space,
        startTime: startTime,
        endTime: endTime,
      ),
    );

    result.when(
      success: (parking) {
        add(AvailableSpacesUpdate());

        // !: Schedule a notification 10 minutes before the parking ends
        _notificationRepository.scheduleParkingReminder(
          id: parking.id.hashCode,
          endTime: endTime,
        );
      },
      failure: (error) => emit(AvailableSpacesFailure(message: error)),
    );
  }

  Future<void> _onUpdate(
    AvailableSpacesUpdate event,
    Emitter<AvailableSpacesState> emit,
  ) async {
    await loadAllParkings(emit);
  }

  Future<void> loadAllParkings(
    Emitter<AvailableSpacesState> emit,
  ) async {
    emit(AvailableSpacesLoading());

    try {
      List<ParkingSpace> availableSpaces =
          await _parkingSpaceRepository.findAvailableSpaces();

      emit(AvailableSpacesLoaded(spaces: availableSpaces));
    } catch (_) {
      emit(AvailableSpacesFailure(message: "Unexpected error"));
    }
  }
}
