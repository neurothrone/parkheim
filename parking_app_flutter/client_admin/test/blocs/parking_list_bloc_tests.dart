import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:client_admin/src/features/parkings/state/parking_list_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../shared/fakes.dart';
import '../shared/mocks.dart';

void main() {
  group("ParkingListBloc", () {
    late RemoteParkingRepository remoteParkingRepository;

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
    final ParkingSpace randomParkingSpace = ParkingSpace(
      id: 1,
      address: "123 Main St",
      pricePerHour: 10.0,
    );
    const String addressToSearchFor = "ABC Street 12";
    final List<Parking> parkings = [
      Parking(
        id: 1,
        vehicle: vehicle,
        parkingSpace: ParkingSpace(
          id: 1,
          address: addressToSearchFor,
          pricePerHour: 10.0,
        ),
        startTime: DateTime.now().add(const Duration(hours: -8)),
        endTime: DateTime.now().add(const Duration(hours: -4)),
      ),
      Parking(
        id: 2,
        vehicle: vehicle,
        parkingSpace: randomParkingSpace,
        startTime: DateTime.now().add(const Duration(hours: -18)),
        endTime: DateTime.now().add(const Duration(hours: -9)),
      ),
    ];

    setUp(() {
      remoteParkingRepository = MockRemoteParkingRepository();
    });

    setUpAll(() {
      registerFallbackValue(FakeParking());
    });

    group("ParkingListBloc tests", () {
      blocTest<ParkingListBloc, ParkingListState>(
        "emits [ParkingListLoading, ParkingListFailure] when loading active parkings fails",
        setUp: () {
          when(() => remoteParkingRepository.findActiveParkings())
              .thenAnswer((_) async => Result.failure(error: "Error"));
        },
        build: () => ParkingListBloc(
          remoteParkingRepository: remoteParkingRepository,
        ),
        seed: () => ParkingListInitial(),
        act: (bloc) => bloc.add(ParkingListLoadActiveItems()),
        expect: () => [
          ParkingListLoading(),
          ParkingListFailure(message: "Error"),
        ],
        verify: (_) {
          verify(() => remoteParkingRepository.findActiveParkings()).called(1);
        },
      );

      blocTest<ParkingListBloc, ParkingListState>(
        "emits [ParkingListLoading, ParkingListLoaded] when loading active parkings initially empty succeeds",
        setUp: () {
          when(() => remoteParkingRepository.findActiveParkings())
              .thenAnswer((_) async => Result.success(value: []));
        },
        build: () => ParkingListBloc(
          remoteParkingRepository: remoteParkingRepository,
        ),
        seed: () => ParkingListInitial(),
        act: (bloc) => bloc.add(ParkingListLoadActiveItems()),
        expect: () => [
          ParkingListLoading(),
          ParkingListLoaded(parkings: []),
        ],
        verify: (_) {
          verify(() => remoteParkingRepository.findActiveParkings()).called(1);
        },
      );

      blocTest<ParkingListBloc, ParkingListState>(
        "emits [ParkingListLoading, ParkingListLoaded] when loading all parkings initially empty succeeds",
        setUp: () {
          when(() => remoteParkingRepository.findAllParkingsSortedByStartTime())
              .thenAnswer((_) async => Result.success(value: []));
        },
        build: () => ParkingListBloc(
          remoteParkingRepository: remoteParkingRepository,
        ),
        seed: () => ParkingListInitial(),
        act: (bloc) => bloc.add(ParkingListLoadAllItems()),
        expect: () => [
          ParkingListLoading(),
          ParkingListLoaded(parkings: []),
        ],
        verify: (_) {
          verify(() =>
                  remoteParkingRepository.findAllParkingsSortedByStartTime())
              .called(1);
        },
      );

      blocTest<ParkingListBloc, ParkingListState>(
        "emits [ParkingListLoading, ParkingListLoaded] when loading all parkings is not empty",
        setUp: () {
          when(() => remoteParkingRepository.findAllParkingsSortedByStartTime())
              .thenAnswer((_) async => Result.success(value: parkings));
        },
        build: () => ParkingListBloc(
          remoteParkingRepository: remoteParkingRepository,
        ),
        seed: () => ParkingListInitial(),
        act: (bloc) => bloc.add(ParkingListLoadAllItems()),
        expect: () => [
          ParkingListLoading(),
          ParkingListLoaded(parkings: parkings),
        ],
        verify: (_) {
          verify(() =>
                  remoteParkingRepository.findAllParkingsSortedByStartTime())
              .called(1);
        },
      );

      blocTest<ParkingListBloc, ParkingListState>(
        "emits [ParkingListLoading, ParkingListLoaded] when searching parkings with no results",
        setUp: () {
          when(() => remoteParkingRepository.searchParkings(any()))
              .thenAnswer((_) async => Result.success(value: []));
        },
        build: () => ParkingListBloc(
          remoteParkingRepository: remoteParkingRepository,
        ),
        seed: () => ParkingListInitial(),
        act: (bloc) => bloc.add(ParkingListSearchItems(searchText: "abc")),
        expect: () => [
          ParkingListLoading(),
          ParkingListLoaded(parkings: []),
        ],
        verify: (_) {
          verify(() => remoteParkingRepository.searchParkings("abc")).called(1);
        },
      );

      blocTest<ParkingListBloc, ParkingListState>(
        "emits [ParkingListLoading, ParkingListLoaded] when searching parkings yields a result",
        setUp: () {
          when(() => remoteParkingRepository.searchParkings(any()))
              .thenAnswer((_) async => Result.success(value: [parkings.first]));
        },
        build: () => ParkingListBloc(
          remoteParkingRepository: remoteParkingRepository,
        ),
        seed: () => ParkingListInitial(),
        act: (bloc) => bloc.add(ParkingListSearchItems(searchText: "abc")),
        expect: () => [
          ParkingListLoading(),
          ParkingListLoaded(parkings: [parkings.first]),
        ],
        verify: (_) {
          verify(() => remoteParkingRepository.searchParkings("abc")).called(1);
        },
      );
    });
  });
}
