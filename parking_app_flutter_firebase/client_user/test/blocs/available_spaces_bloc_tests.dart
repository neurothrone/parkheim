import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:client_user/src/features/parkings/state/available_spaces/available_spaces_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

import '../shared/fakes.dart';
import '../shared/mocks.dart';

void main() {
  group("AvailableSpacesBloc", () {
    late FirebaseParkingRepository remoteParkingRepository;
    late FirebaseParkingSpaceRepository remoteParkingSpaceRepository;

    final Person owner = Person(
      id: "VFa5T4QYQnqayx6ob1E1",
      name: "Zane Doe",
      socialSecurityNumber: "199001011239",
    );
    final Vehicle vehicle = Vehicle(
      id: "VFa5T4QYQnqayx6ob1E2",
      registrationNumber: "ABC123",
      vehicleType: VehicleType.car,
      owner: owner,
    );
    final ParkingSpace parkingSpace = ParkingSpace(
      id: "VFa5T4QYQnqayx6ob1E3",
      address: "123 Main St",
      pricePerHour: 10.0,
    );
    final Parking newParking = Parking(
      id: "VFa5T4QYQnqayx6ob1E4",
      vehicle: vehicle,
      parkingSpace: parkingSpace,
      startTime: DateTime.now(),
      endTime: null,
    );

    setUp(() {
      remoteParkingRepository = MockRemoteParkingRepository();
      remoteParkingSpaceRepository = MockRemoteParkingSpaceRepository();
    });

    setUpAll(() {
      registerFallbackValue(FakePerson());
      registerFallbackValue(FakeVehicle());
      registerFallbackValue(FakeParkingSpace());
      registerFallbackValue(FakeParking());
    });

    group("Available Spaces Bloc tests", () {
      blocTest<AvailableSpacesBloc, AvailableSpacesState>(
        "emits [AllParkingLoading, AllParkingFailure] when initially empty failure",
        setUp: () {
          when(() => remoteParkingSpaceRepository.findAvailableSpaces())
              .thenThrow(Exception("Unexpected error"));
        },
        build: () => AvailableSpacesBloc(
          parkingRepository: remoteParkingRepository,
          parkingSpaceRepository: remoteParkingSpaceRepository,
        ),
        seed: () => AvailableSpacesInitial(),
        act: (bloc) => bloc.add(AvailableSpacesLoad()),
        expect: () => [
          AvailableSpacesLoading(),
          AvailableSpacesFailure(message: "Unexpected error"),
        ],
        verify: (_) {
          verify(() => remoteParkingSpaceRepository.findAvailableSpaces())
              .called(1);
        },
      );

      blocTest<AvailableSpacesBloc, AvailableSpacesState>(
        "emits [AllParkingLoading, AllParkingLoaded] when initially empty success",
        setUp: () {
          when(() => remoteParkingSpaceRepository.findAvailableSpaces())
              .thenAnswer((_) async => []);
        },
        build: () => AvailableSpacesBloc(
          parkingRepository: remoteParkingRepository,
          parkingSpaceRepository: remoteParkingSpaceRepository,
        ),
        seed: () => AvailableSpacesInitial(),
        act: (bloc) => bloc.add(AvailableSpacesLoad()),
        expect: () => [
          AvailableSpacesLoading(),
          AvailableSpacesLoaded(spaces: []),
        ],
        verify: (_) {
          verify(() => remoteParkingSpaceRepository.findAvailableSpaces())
              .called(1);
        },
      );

      blocTest<AvailableSpacesBloc, AvailableSpacesState>(
        "emits [AllParkingLoading, AllParkingLoaded] when spaces are available",
        setUp: () {
          when(() => remoteParkingSpaceRepository.findAvailableSpaces())
              .thenAnswer((_) async => [parkingSpace]);
        },
        build: () => AvailableSpacesBloc(
          parkingRepository: remoteParkingRepository,
          parkingSpaceRepository: remoteParkingSpaceRepository,
        ),
        seed: () => AvailableSpacesInitial(),
        act: (bloc) => bloc.add(AvailableSpacesLoad()),
        expect: () => [
          AvailableSpacesLoading(),
          AvailableSpacesLoaded(spaces: [parkingSpace]),
        ],
        verify: (_) {
          verify(() => remoteParkingSpaceRepository.findAvailableSpaces())
              .called(1);
        },
      );

      blocTest<AvailableSpacesBloc, AvailableSpacesState>(
        "emits [AvailableSpacesLoading, AvailableSpacesLoaded] when parking is started successfully",
        setUp: () {
          when(() => remoteParkingRepository.create(any()))
              .thenAnswer((_) async => Result.success(value: newParking));
          when(() => remoteParkingSpaceRepository.findAvailableSpaces())
              .thenAnswer((_) async => []);
        },
        build: () => AvailableSpacesBloc(
          parkingRepository: remoteParkingRepository,
          parkingSpaceRepository: remoteParkingSpaceRepository,
        ),
        seed: () => AvailableSpacesLoaded(spaces: [parkingSpace]),
        act: (bloc) => bloc.add(
          AvailableSpacesStartParking(
            space: parkingSpace,
            vehicle: vehicle,
          ),
        ),
        expect: () => [
          AvailableSpacesLoading(),
          AvailableSpacesLoaded(spaces: []),
        ],
        verify: (_) {
          verify(() => remoteParkingRepository.create(any())).called(1);
          verify(() => remoteParkingSpaceRepository.findAvailableSpaces())
              .called(1);
        },
      );
    });
  });
}
