import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:client_user/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:client_user/src/core/cubits/app_user/app_user_state.dart';
import 'package:client_user/src/core/entities/user_entity.dart';
import 'package:client_user/src/data/repositories/notification_repository.dart';
import 'package:client_user/src/features/parkings/state/active_parkings/active_parkings_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

import '../shared/fakes.dart';
import '../shared/mocks.dart';

void main() {
  group("ActiveParkingsBloc", () {
    late FirebasePersonRepository remotePersonRepository;
    late FirebaseParkingRepository remoteParkingRepository;
    late NotificationRepository notificationRepository;

    late AppUserCubit appUserCubit;
    final UserEntity user = UserEntity(
      id: "VFa5T4QYQnqayx6ob1E1",
      email: "zane@example.com",
      displayName: "Zane Doe",
    );
    final Person owner = Person(
      id: "VFa5T4QYQnqayx6ob1E2",
      name: "Zane Doe",
      socialSecurityNumber: "199001011239",
    );
    final Vehicle vehicle = Vehicle(
      id: "VFa5T4QYQnqayx6ob1E3",
      registrationNumber: "ABC123",
      vehicleType: VehicleType.car,
      owner: owner,
    );
    final ParkingSpace parkingSpace = ParkingSpace(
      id: "VFa5T4QYQnqayx6ob1E4",
      address: "123 Main St",
      pricePerHour: 10.0,
    );
    final Parking newParking = Parking(
      id: "VFa5T4QYQnqayx6ob1E6",
      vehicle: vehicle,
      parkingSpace: parkingSpace,
      startTime: DateTime.now().add(const Duration(hours: -2)),
      endTime: DateTime.now().add(const Duration(hours: 2)),
    );

    setUp(() {
      remotePersonRepository = MockRemotePersonRepository();
      remoteParkingRepository = MockRemoteParkingRepository();
      notificationRepository = MockNotificationRepository();

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
          notificationRepository: notificationRepository,
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
          notificationRepository: notificationRepository,
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
          notificationRepository: notificationRepository,
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
