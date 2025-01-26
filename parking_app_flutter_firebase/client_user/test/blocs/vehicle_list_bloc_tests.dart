import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:client_user/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:client_user/src/core/cubits/app_user/app_user_state.dart';
import 'package:client_user/src/core/entities/user_entity.dart';
import 'package:client_user/src/features/vehicles/state/vehicle_list_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

import '../shared/fakes.dart';
import '../shared/mocks.dart';

void main() {
  group("VehicleListBloc", () {
    late FirebasePersonRepository remotePersonRepository;
    late FirebaseVehicleRepository remoteVehicleRepository;

    late AppUserCubit appUserCubit;
    final UserEntity user = UserEntity(
      id: "199001011239",
      email: "zane@example.com",
      displayName: "Zane Doe",
    );
    final Person owner = Person(
      id: "VFa5T4QYQnqayx6ob1E1",
      name: "Zane Doe",
      socialSecurityNumber: "199001011239",
    );
    final List<Vehicle> vehicles = [
      Vehicle(
        id: "VFa5T4QYQnqayx6ob1E2",
        registrationNumber: "ABC123",
        vehicleType: VehicleType.car,
        owner: owner,
      ),
    ];
    final Vehicle newVehicle = Vehicle(
      id: "VFa5T4QYQnqayx6ob1E3",
      registrationNumber: "XDF442",
      vehicleType: VehicleType.motorcycle,
      owner: owner,
    );

    setUp(() {
      remotePersonRepository = MockRemotePersonRepository();
      remoteVehicleRepository = MockRemoteVehicleRepository();

      appUserCubit = MockAppUserCubit();
      when(() => appUserCubit.state).thenReturn(AppUserSignedIn(user: user));
    });

    setUpAll(() {
      registerFallbackValue(FakePerson());
      registerFallbackValue(FakeVehicle());
    });

    group("Vehicle List tests", () {
      blocTest<VehicleListBloc, VehicleListState>(
        "emits [VehicleListLoading, VehicleListFailure] when listing owned vehicles fails",
        setUp: () {
          when(() => remotePersonRepository.findPersonByName(any()))
              .thenAnswer((_) async => Result.success(value: owner));
          when(() => remoteVehicleRepository.findVehiclesByOwner(any()))
              .thenAnswer((_) async => Result.failure(error: "Error"));
        },
        build: () => VehicleListBloc(
          appUserCubit: appUserCubit,
          personRepository: remotePersonRepository,
          vehicleRepository: remoteVehicleRepository,
        ),
        seed: () => VehicleListInitial(),
        act: (bloc) => bloc.add(VehicleListLoad()),
        expect: () => [
          VehicleListLoading(),
          VehicleListFailure(message: "Error"),
        ],
        verify: (_) {
          verify(() =>
                  remotePersonRepository.findPersonByName(user.displayName!))
              .called(1);
          verify(() => remoteVehicleRepository.findVehiclesByOwner(owner))
              .called(1);
        },
      );

      blocTest<VehicleListBloc, VehicleListState>(
        "emits [VehicleListLoading, VehicleListLoaded] when listing owned vehicles succeeds",
        setUp: () {
          when(() => remotePersonRepository.findPersonByName(any()))
              .thenAnswer((_) async => Result.success(value: owner));
          when(() => remoteVehicleRepository.findVehiclesByOwner(any()))
              .thenAnswer((_) async => Result.success(value: vehicles));
        },
        build: () => VehicleListBloc(
          appUserCubit: appUserCubit,
          personRepository: remotePersonRepository,
          vehicleRepository: remoteVehicleRepository,
        ),
        seed: () => VehicleListInitial(),
        act: (bloc) => bloc.add(VehicleListLoad()),
        expect: () => [
          VehicleListLoading(),
          VehicleListLoaded(vehicles: vehicles),
        ],
        verify: (_) {
          verify(() =>
                  remotePersonRepository.findPersonByName(user.displayName!))
              .called(1);
          verify(() => remoteVehicleRepository.findVehiclesByOwner(owner))
              .called(1);
        },
      );

      blocTest<VehicleListBloc, VehicleListState>(
        "emits [VehicleListLoading, VehicleListLoaded] when listing owned vehicles after adding a vehicle",
        setUp: () {
          when(() => remotePersonRepository.findPersonByName(any()))
              .thenAnswer((_) async => Result.success(value: owner));
          when(() => remoteVehicleRepository.findVehiclesByOwner(any()))
              .thenAnswer((_) async => Result.success(value: [
                    ...vehicles,
                    newVehicle,
                  ]));
          when(() => remoteVehicleRepository.create(any()))
              .thenAnswer((_) async => Result.success(value: newVehicle));
        },
        build: () => VehicleListBloc(
          appUserCubit: appUserCubit,
          personRepository: remotePersonRepository,
          vehicleRepository: remoteVehicleRepository,
        ),
        seed: () => VehicleListInitial(),
        act: (bloc) => bloc.add(VehicleListUpdate()),
        expect: () => [
          VehicleListLoading(),
          VehicleListLoaded(vehicles: [
            ...vehicles,
            newVehicle,
          ]),
        ],
        verify: (_) {
          verify(() =>
                  remotePersonRepository.findPersonByName(user.displayName!))
              .called(1);
          verify(() => remoteVehicleRepository.findVehiclesByOwner(owner))
              .called(1);
        },
      );
    });
  });
}
