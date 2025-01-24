import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:client_user/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:client_user/src/core/cubits/app_user/app_user_state.dart';
import 'package:client_user/src/core/entities/user_entity.dart';
import 'package:client_user/src/features/parkings/state/active_parkings/active_parkings_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../shared/fakes.dart';
import '../shared/mocks.dart';

void main() {
  group("ActiveParkingsBloc", () {
    late RemotePersonRepository remotePersonRepository;
    late RemoteParkingRepository remoteParkingRepository;

    late AppUserCubit appUserCubit;
    final UserEntity user = UserEntity(
      id: "199001011239",
      email: "zane@example.com",
      displayName: "Zane Doe",
    );
    final Person owner = Person(
      id: 1,
      name: "Zane Doe",
      socialSecurityNumber: "199001011239",
    );
    final Vehicle vehicle = Vehicle(
      id: 1,
      registrationNumber: "ABC123",
      vehicleType: VehicleType.car,
      owner: owner,
    );
    final ParkingSpace parkingSpace = ParkingSpace(
      id: 1,
      address: "123 Main St",
      pricePerHour: 10.0,
    );
    final List<Parking> parkings = [
      Parking(
        id: 1,
        vehicle: vehicle,
        parkingSpace: parkingSpace,
        startTime: DateTime.now().add(const Duration(hours: -8)),
        endTime: DateTime.now().add(const Duration(hours: -4)),
      ),
    ];
    final Parking newParking = Parking(
      id: 2,
      vehicle: vehicle,
      parkingSpace: parkingSpace,
      startTime: DateTime.now().add(const Duration(hours: -2)),
      endTime: null,
    );

    setUp(() {
      remotePersonRepository = MockRemotePersonRepository();
      remoteParkingRepository = MockRemoteParkingRepository();

      appUserCubit = MockAppUserCubit();
      when(() => appUserCubit.state).thenReturn(AppUserSignedIn(user: user));
    });

    setUpAll(() {
      registerFallbackValue(FakePerson());
      registerFallbackValue(FakeParking());
    });

    group("Active Parkings tests", () {
      blocTest<ActiveParkingsBloc, ActiveParkingsState>(
        "emits [ActiveParkingLoading, ActiveParkingFailure] when initially failure",
        setUp: () {
          when(() => remotePersonRepository.findPersonByName(any())).thenAnswer(
              (_) async => Result.failure(error: "Owner not found"));
          when(() => remoteParkingRepository.findActiveParkingsForOwner(any()))
              .thenAnswer((_) async => Result.success(value: []));
        },
        build: () => ActiveParkingsBloc(
          appUserCubit: appUserCubit,
          personRepository: remotePersonRepository,
          parkingRepository: remoteParkingRepository,
        ),
        seed: () => ActiveParkingsInitial(),
        act: (bloc) => bloc.add(ActiveParkingLoad()),
        expect: () => [
          ActiveParkingsLoading(),
          ActiveParkingsFailure(message: "Owner not found"),
        ],
        verify: (_) {
          verify(() =>
                  remotePersonRepository.findPersonByName(user.displayName!))
              .called(1);
          verifyNever(
              () => remoteParkingRepository.findActiveParkingsForOwner(owner));
        },
      );

      blocTest<ActiveParkingsBloc, ActiveParkingsState>(
        "emits [ActiveParkingLoading, ActiveParkingLoaded] when initially no parkings",
        setUp: () {
          when(() => remotePersonRepository.findPersonByName(any()))
              .thenAnswer((_) async => Result.success(value: owner));
          when(() => remoteParkingRepository.findActiveParkingsForOwner(any()))
              .thenAnswer((_) async => Result.success(value: []));
        },
        build: () => ActiveParkingsBloc(
          appUserCubit: appUserCubit,
          personRepository: remotePersonRepository,
          parkingRepository: remoteParkingRepository,
        ),
        seed: () => ActiveParkingsInitial(),
        act: (bloc) => bloc.add(ActiveParkingLoad()),
        expect: () => [
          ActiveParkingsLoading(),
          ActiveParkingsLoaded(parkings: []),
        ],
        verify: (_) {
          verify(() =>
                  remotePersonRepository.findPersonByName(user.displayName!))
              .called(1);
          verify(() =>
                  remoteParkingRepository.findActiveParkingsForOwner(owner))
              .called(1);
        },
      );

      blocTest<ActiveParkingsBloc, ActiveParkingsState>(
        "emits [ActiveParkingLoading, ActiveParkingLoaded] after ending a parking",
        setUp: () {
          when(() => remotePersonRepository.findPersonByName(any()))
              .thenAnswer((_) async => Result.success(value: owner));
          when(() => remoteParkingRepository.endParking(any())).thenAnswer(
            (_) async => Result.success(
              value: newParking.copyWith(
                endTime: DateTime.now(),
              ),
            ),
          );
          when(() => remoteParkingRepository.findActiveParkingsForOwner(any()))
              .thenAnswer((_) async => Result.success(value: []));
        },
        build: () => ActiveParkingsBloc(
          appUserCubit: appUserCubit,
          personRepository: remotePersonRepository,
          parkingRepository: remoteParkingRepository,
        ),
        seed: () => ActiveParkingsLoaded(
          parkings: [newParking],
        ),
        act: (bloc) => bloc.add(ActiveParkingEnd(parking: newParking)),
        expect: () => [
          ActiveParkingsLoading(),
          ActiveParkingsLoaded(parkings: []),
        ],
        verify: (_) {
          verify(() =>
                  remotePersonRepository.findPersonByName(user.displayName!))
              .called(1);
          verify(() => remoteParkingRepository.endParking(newParking))
              .called(1);
          verify(() =>
                  remoteParkingRepository.findActiveParkingsForOwner(owner))
              .called(1);
        },
      );
    });
  });
}
