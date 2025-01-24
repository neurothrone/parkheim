import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shared_client_firebase/shared_client_firebase.dart';

import '../../../firebase_options.dart';
import '../../features/auth/state/auth_cubit.dart';
import '../../features/parkings/state/parking_list_bloc.dart';
import '../../features/parkings/state/parking_search_text_cubit.dart';
import '../../features/parkings/state/parking_tab_cubit.dart';
import '../../features/spaces/state/space_history_bloc.dart';
import '../../features/spaces/state/spaces_list_bloc.dart';
import '../../features/statistics/state/active_parking_count_bloc.dart';
import '../../features/statistics/state/most_popular_spaces_bloc.dart';
import '../../features/statistics/state/parking_revenue_bloc.dart';
import '../navigation/navigation_rail_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  // !: Auth Cubit
  serviceLocator.registerLazySingleton(() => AuthCubit());

  // !: Navigation Rail Cubit
  serviceLocator.registerLazySingleton(() => NavigationRailCubit());

  // !: Parking Tab Cubit
  serviceLocator.registerLazySingleton(() => ParkingTabCubit());

  // !: Parking Search Text Cubit
  serviceLocator.registerLazySingleton(() => ParkingSearchTextCubit());

  // !: Remote Repositories
  serviceLocator
    ..registerLazySingleton(() => FirebasePersonRepository())
    ..registerLazySingleton(() => FirebaseVehicleRepository())
    ..registerLazySingleton(
        () => FirebaseParkingRepository(vehicleRepository: serviceLocator()))
    ..registerLazySingleton(() =>
        FirebaseParkingSpaceRepository(parkingRepository: serviceLocator()));

  // !: Spaces & Parking
  serviceLocator
    ..registerLazySingleton(
      () => SpacesListBloc(
        parkingSpaceRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => ParkingListBloc(
        parkingRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => SpaceHistoryBloc(
        parkingRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => ActiveParkingCountBloc(
        parkingRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => MostPopularSpacesBloc(
        parkingRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => ParkingRevenueBloc(
        parkingRepository: serviceLocator(),
      ),
    );
}
