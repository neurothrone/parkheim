import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:client_user/src/features/parkings/state/available_spaces/available_spaces_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../shared/fakes.dart';
import '../shared/mocks.dart';

void main() {
  group("AvailableSpacesBloc", () {
    late RemoteParkingRepository remoteParkingRepository;
    late RemoteParkingSpaceRepository remoteParkingSpaceRepository;

    final ParkingSpace parkingSpace = ParkingSpace(
      id: 1,
      address: "123 Main St",
      pricePerHour: 10.0,
    );

    setUp(() {
      remoteParkingRepository = MockRemoteParkingRepository();
      remoteParkingSpaceRepository = MockRemoteParkingSpaceRepository();
    });

    setUpAll(() {
      registerFallbackValue(FakePerson());
      registerFallbackValue(FakeVehicle());
      registerFallbackValue(FakeParkingSpace());
    });

    group("Available Spaces Bloc tests", () {
      blocTest<AvailableSpacesBloc, AvailableSpacesState>(
        "emits [AllParkingLoading, AllParkingFailure] when initially empty failure",
        setUp: () {
          when(() => remoteParkingSpaceRepository.findAvailableSpaces())
              .thenThrow(Exception("Unexpected error"));
        },
        build: () => AvailableSpacesBloc(
          remoteParkingRepository: remoteParkingRepository,
          remoteParkingSpaceRepository: remoteParkingSpaceRepository,
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
          remoteParkingRepository: remoteParkingRepository,
          remoteParkingSpaceRepository: remoteParkingSpaceRepository,
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
          remoteParkingRepository: remoteParkingRepository,
          remoteParkingSpaceRepository: remoteParkingSpaceRepository,
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
    });
  });
}
