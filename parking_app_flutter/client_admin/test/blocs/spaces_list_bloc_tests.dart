import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:client_admin/src/features/spaces/state/spaces_list_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../shared/fakes.dart';
import '../shared/mocks.dart';

void main() {
  group("SpaceListBloc", () {
    late RemoteParkingSpaceRepository remoteParkingSpaceRepository;

    final ParkingSpace spaceToAdd = ParkingSpace(
      id: 1,
      address: "ABC Street 123",
      pricePerHour: 10.0,
    );

    setUp(() {
      remoteParkingSpaceRepository = MockRemoteParkingSpaceRepository();
    });

    setUpAll(() {
      registerFallbackValue(FakeParkingSpace());
    });

    group("SpaceListBloc tests", () {
      blocTest<SpacesListBloc, SpacesListState>(
        "emits [SpacesListLoading, SpacesListFailure] when loading all spaces fails",
        setUp: () {
          when(() => remoteParkingSpaceRepository.getAll())
              .thenAnswer((_) async => Result.failure(error: "Error"));
        },
        build: () => SpacesListBloc(
          remoteParkingSpaceRepository: remoteParkingSpaceRepository,
        ),
        seed: () => SpacesListInitial(),
        act: (bloc) => bloc.add(SpacesListLoad()),
        expect: () => [
          SpacesListLoading(),
          SpacesListFailure(message: "Error"),
        ],
        verify: (_) {
          verify(() => remoteParkingSpaceRepository.getAll()).called(1);
        },
      );

      blocTest<SpacesListBloc, SpacesListState>(
        "emits [SpacesListLoading, SpacesListLoaded] when loading all spaces initially empty succeeds",
        setUp: () {
          when(() => remoteParkingSpaceRepository.getAll())
              .thenAnswer((_) async => Result.success(value: []));
        },
        build: () => SpacesListBloc(
          remoteParkingSpaceRepository: remoteParkingSpaceRepository,
        ),
        seed: () => SpacesListInitial(),
        act: (bloc) => bloc.add(SpacesListLoad()),
        expect: () => [
          SpacesListLoading(),
          SpacesListLoaded(spaces: []),
        ],
        verify: (_) {
          verify(() => remoteParkingSpaceRepository.getAll()).called(1);
        },
      );

      blocTest<SpacesListBloc, SpacesListState>(
        "emits [SpacesListLoading, SpacesListLoaded] when adding a space succeeds",
        setUp: () {
          when(() => remoteParkingSpaceRepository.create(any()))
              .thenAnswer((_) async => Result.success(value: spaceToAdd));
          when(() => remoteParkingSpaceRepository.getAll())
              .thenAnswer((_) async => Result.success(value: [spaceToAdd]));
        },
        build: () => SpacesListBloc(
          remoteParkingSpaceRepository: remoteParkingSpaceRepository,
        ),
        seed: () => SpacesListLoaded(spaces: []),
        act: (bloc) => bloc.add(SpacesListAddItem(space: spaceToAdd)),
        expect: () => [
          SpacesListLoading(),
          SpacesListLoaded(spaces: [spaceToAdd]),
        ],
        verify: (_) {
          verify(() => remoteParkingSpaceRepository.create(spaceToAdd))
              .called(1);
          verify(() => remoteParkingSpaceRepository.getAll()).called(1);
        },
      );

      blocTest<SpacesListBloc, SpacesListState>(
        "emits [SpacesListLoading, SpacesListLoaded] when deleting a space succeeds",
        setUp: () {
          when(() => remoteParkingSpaceRepository.delete(any()))
              .thenAnswer((_) async => Result.success(value: spaceToAdd));
          when(() => remoteParkingSpaceRepository.getAll())
              .thenAnswer((_) async => Result.success(value: []));
        },
        build: () => SpacesListBloc(
          remoteParkingSpaceRepository: remoteParkingSpaceRepository,
        ),
        seed: () => SpacesListLoaded(spaces: [spaceToAdd]),
        act: (bloc) => bloc.add(SpacesListDeleteItem(id: spaceToAdd.id)),
        expect: () => [
          SpacesListLoading(),
          SpacesListLoaded(spaces: []),
        ],
        verify: (_) {
          verify(() => remoteParkingSpaceRepository.delete(spaceToAdd.id))
              .called(1);
          verify(() => remoteParkingSpaceRepository.getAll()).called(1);
        },
      );
    });
  });
}
